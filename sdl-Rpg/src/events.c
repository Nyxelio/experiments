/*
** event.c
**
** Gère le système d'événements
**
** Rôle:
** - initialise et libère les événements
** - gère le déclenchement et le déroulenement des événements
*/
#include "../inc/events.h"
 
void InitLibEvent(struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     unsigned int i;
 
     InitEvent(&libevent->global_event);
     libevent->map_event=malloc(map->width*map->height*sizeof(struct s_event));
     for(i=0;i<map->width*map->height;i++)
        InitEvent(&libevent->map_event[i]);
     libevent->sprite_event=malloc(libsprite->n_sprite*sizeof(struct s_event));
     for(i=0;i<libsprite->n_sprite;i++)
        InitEvent(&libevent->sprite_event[i]);
}
 
void InitEvent(struct s_event *event)
{
     event->type=EVENT_NULL;
     event->onaction=EVENT_ACTION_AUTO;
     event->proba=0;
     event->param=NULL;
     event->player_anim=-1;
     event->sound=NULL;
     event->is_unique=0;
     event->next=NULL;
}
 
void FreeLibEvent(struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     int i;
     FreeEvent(&libevent->global_event);
     for(i=0;i<map->width*map->height;i++)
        FreeEvent(&libevent->map_event[i]);
     free(libevent->map_event);
     for(i=0;i<libsprite->n_sprite;i++)
        FreeEvent(&libevent->sprite_event[i]);
     free(libevent->sprite_event);
}
 
void FreeEvent(struct s_event *event)
{
     struct s_event *next;
 
     if(!event) return;
     event=event->next;
     while(event)
     {
        next=event->next;
        if(event->sound) FSOUND_Sample_Free(event->sound);
        switch(event->type)
        {
           case EVENT_NULL:
                break;
           case EVENT_TELEPORT:
                free(((struct s_event_param_teleport*)event->param)->filename);
                free((struct s_event_param_teleport*)event->param);
                break;
           case EVENT_DIALOG:
                free(((struct s_event_param_dialog*)event->param)->dialog);
                free((struct s_event_param_dialog*)event->param);
                break;
           case EVENT_BATTLE:
                free((struct s_event_param_battle*)event->param);
                break;
           case EVENT_SHOP:
                free((struct s_event_param_shop*)event->param);
                break;
           case EVENT_INN:
                free((struct s_event_param_inn*)event->param);
                break;
        }
        free(event);
        event=next;
     }
}
 
void HandleEvent(struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     unsigned int tx, ty, i;
     struct s_event *event;
     /* Test des événements qui se produisent automatiquement */
     /* GLOBAL */
     event=&libevent->global_event;
     while(event)
     {
        if ((event->onaction==EVENT_ACTION_AUTO) && (RND_EVENT_SUCCESS(*event)))
           if(DoEvent(event, libevent, map, libsprite))
             return;
        event=event->next;
     }
 
     /* MAP    */
     tx  = (2*libsprite->sprites[0].x+2*libsprite->sprites[0].offsetG+TILE_WIDTH-libsprite->sprites[0].offsetD)/(2*TILE_WIDTH);
     ty  = (2*libsprite->sprites[0].y+2*libsprite->sprites[0].offsetH+TILE_HEIGHT-libsprite->sprites[0].offsetB)/(2*TILE_HEIGHT);
 
     event=&GET_MAPEVENT(tx,ty,map,libevent);
     while(event)
     {
        if ( (event->onaction==EVENT_ACTION_AUTO) && (RND_EVENT_SUCCESS(*event)) )
           if(DoEvent(event, libevent, map, libsprite))
             return;
        event=event->next;
     }
 
     /* SPRITE */
     /* inutile de tester 0, c'est le joueur! */
     for(i=1;i<libsprite->n_sprite;i++)
     {
        event=&libevent->sprite_event[i];
        while(event)
        {
           if(IS_NEAR(libsprite->sprites[0].x,libsprite->sprites[i].x,libsprite->sprites[0].y,libsprite->sprites[i].y,TILE_WIDTH/2))
              if ((event->onaction==EVENT_ACTION_AUTO) && (RND_EVENT_SUCCESS(*event)) )
                  if(DoEvent(event, libevent, map, libsprite))
                    return;
           event=event->next;
        }
     }
}
 
void Event(SDL_Event *sdlevent, struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     unsigned int tx, ty, i;
     struct s_event *event;
 
     switch(sdlevent->type)
     {
      case SDL_KEYDOWN:
	    if(sdlevent->key.state==SDL_PRESSED)
	    {
          if(sdlevent->key.keysym.sym==SDLK_SPACE)
          {
             /* Test des événements qui se produisent quand on appuie sur une touche */
             /* GLOBAL */
             event=&libevent->global_event;
             while(event)
             {
                if ((event->onaction==EVENT_ACTION_ONKEYPRESS) && (RND_EVENT_SUCCESS(*event)))
                   if(DoEvent(event, libevent, map, libsprite))
                     return;
                event=event->next;
             }
 
             /* MAP    */
             tx  = (2*libsprite->sprites[0].x+2*libsprite->sprites[0].offsetG+TILE_WIDTH-libsprite->sprites[0].offsetD)/(2*TILE_WIDTH);
             ty  = (2*libsprite->sprites[0].y+2*libsprite->sprites[0].offsetH+TILE_HEIGHT-libsprite->sprites[0].offsetB)/(2*TILE_HEIGHT);
 
             event=&GET_MAPEVENT(tx,ty,map,libevent);
             while(event)
             {
                if ( (event->onaction==EVENT_ACTION_ONKEYPRESS) && (RND_EVENT_SUCCESS(*event)) )
                   if(DoEvent(event, libevent, map, libsprite))
                     return;
                event=event->next;
             }
 
             /* SPRITE */
             /* inutile de tester 0, c'est le joueur! */
             for(i=1;i<libsprite->n_sprite;i++)
             {
                event=&libevent->sprite_event[i];
                while(event)
                {
                   if(IS_NEAR(libsprite->sprites[0].x,libsprite->sprites[i].x,libsprite->sprites[0].y,libsprite->sprites[i].y,TILE_WIDTH/2))
                      if ((event->onaction==EVENT_ACTION_ONKEYPRESS) && (RND_EVENT_SUCCESS(*event)) )
                         if(DoEvent(event, libevent, map, libsprite))
                           return;
                   event=event->next;
                }
             }
          } /* !event->key.state==SDL_PRESSED */
        }
        break;
     }
}
 
int DoEvent(struct s_event *event, struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     if(!event) return 0;
     if(event->type==EVENT_NULL) return 0;
 
     if(event->sound) FSOUND_PlaySound(FSOUND_FREE,event->sound);
 
     switch(event->type)
     {
        case EVENT_TELEPORT:
           DoEventTeleport(event, libevent, map, libsprite);
           return 1;
           break;
        case EVENT_DIALOG:
           DoEventDialog(event, libevent, map, libsprite);
           break;
        case EVENT_BATTLE:
           DoEventBattle(event, libevent, map, libsprite);
           break;
        case EVENT_SHOP:
           DoEventShop(event, libevent, map, libsprite);
           break;
        case EVENT_INN:
           DoEventInn(event, libevent, map, libsprite);
           break;
        default:
           break;
     }
 
     if(event->is_unique)
     {
        /* suppr. de l'événement */
        switch(event->type)
        {
           case EVENT_NULL:
                break;
           case EVENT_TELEPORT:
                free((struct s_event_param_teleport*)event->param);
                break;
           case EVENT_DIALOG:
                free((struct s_event_param_dialog*)event->param);
                break;
           case EVENT_BATTLE:
                free((struct s_event_param_battle*)event->param);
                break;
           case EVENT_SHOP:
                free((struct s_event_param_shop*)event->param);
                break;
           case EVENT_INN:
                free((struct s_event_param_inn*)event->param);
                break;
        }
        event->type=EVENT_NULL;
        event->onaction=EVENT_ACTION_AUTO;
     }
 
  return 0;
}
 
void LoadEvent(struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite, char *filename)
{
     FILE *f;
     struct s_event *event;
     unsigned int n_event, x, y, i, spr;
 
     InitLibEvent(libevent,map,libsprite);
 
     f=fopen(filename,"rb");
     if(!f) return;
 
     /* GLOBAL */
     n_event=0;
     fread(&n_event, sizeof(unsigned int), 1, f);
 
     ReadEvent(f, &libevent->global_event);
 
     event=&libevent->global_event;
     for(i=1;i<n_event;i++)
     {
        event->next=calloc(1,sizeof(struct s_event));
        event->next=event;
        ReadEvent(f, event);
     }
     event->next=NULL;
 
     /* MAP    */
     for(x=0;x<map->width;x++)
        for(y=0;y<map->height;y++)
        {
           n_event=0;
           fread(&n_event, sizeof(unsigned int), 1, f);
 
           ReadEvent(f, &GET_MAPEVENT(x,y,map,libevent));
 
           event=&GET_MAPEVENT(x,y,map,libevent);
 
           for(i=1;i<n_event;i++)
           {
              event->next=calloc(1,sizeof(struct s_event));
              event->next=event;
 
              ReadEvent(f,event);
           }
           event->next=NULL;
        } /* !y<map->height */
 
     /* SPRITE */
     for(spr=0;spr<libsprite->n_sprite;spr++)
     {
           n_event=0;
           fread(&n_event, sizeof(unsigned int), 1, f);
 
           ReadEvent(f, &libevent->sprite_event[spr]);
 
           event=&libevent->sprite_event[spr];
           for(i=1;i<n_event;i++)
           {
              event->next=calloc(1,sizeof(struct s_event));
              event->next=event;
              ReadEvent(f,event);
           }
           event->next=NULL;
     } /* !spr<libsprite->n_sprite */
     fclose(f);
}
 
void ReadEvent(FILE *f, struct s_event *event)
{
  char buffer[256];
 
  InitEvent(event);
 
  fread(&event->type, sizeof(enum e_event_type), 1, f);
  if(event->type==EVENT_NULL)
     return;
 
  fread(&event->onaction, sizeof(enum e_event_action), 1, f);
  fread(&event->proba, sizeof(unsigned char), 1, f);
  fread(&event->player_anim, sizeof(unsigned int), 1, f);
  fread(&event->is_unique, sizeof(unsigned char), 1, f);
 
  memset(&buffer,0,sizeof(buffer));
  fread(&buffer,63,sizeof(char),f);
  event->sound=FSOUND_Sample_Load(FSOUND_FREE,buffer,FSOUND_NORMAL,0,0);
 
  switch(event->type)
  {
    case EVENT_NULL:
      break;
    case EVENT_TELEPORT:
      event->param=calloc(1,sizeof(struct s_event_param_teleport));
      memset(&buffer,0,sizeof(buffer));
      fread(&buffer,63,sizeof(char),f);
      if(buffer[0]==0)
        ((struct s_event_param_teleport*)event->param)->filename=NULL;
      else
        ((struct s_event_param_teleport*)event->param)->filename=strdup(buffer);
 
      fread(&((struct s_event_param_teleport*)event->param)->startX, sizeof(unsigned int), 1, f);
      fread(&((struct s_event_param_teleport*)event->param)->startY, sizeof(unsigned int), 1, f);
      break;
    case EVENT_DIALOG:
      event->param=malloc(sizeof(struct s_event_param_dialog));
      memset(&buffer,0,sizeof(buffer));
      fread(&buffer,255,sizeof(char),f);
      ((struct s_event_param_dialog*)event->param)->dialog=strdup(buffer);
      break;
    case EVENT_BATTLE:
      break;
    case EVENT_SHOP:
      break;
    case EVENT_INN:
      break;
  }
}
 
 
void SaveEvent(struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite, char *bg_sound, char *filename)
{
     FILE *f;
     struct s_event *event;
     unsigned int n_event, x, y, i;
 
     f=fopen(filename,"wb");
     if(!f) return;
 
     /* GLOBAL */
     n_event=0;
     event=&libevent->global_event;
     while(event)
     {
        n_event++;
        event=event->next;
     }
     fwrite(&n_event, sizeof(unsigned int), 1, f);
 
     event=&libevent->global_event;
     while(event)
     {
       WriteEvent(f, event, bg_sound);
       event=event->next;
     }
 
     /* MAP    */
     for(x=0;x<map->width;x++)
        for(y=0;y<map->height;y++)
        {
           n_event=0;
           event=&GET_MAPEVENT(x,y,map,libevent);
           while(event)
           {
              n_event++;
              event=event->next;
           }
           fwrite(&n_event, sizeof(unsigned int), 1, f);
 
           event=&GET_MAPEVENT(x,y,map,libevent);
           while(event)
           {
              WriteEvent(f, event, bg_sound);
              event=event->next;
           }
        } /* !y<map->height */
     /* SPRITE */
     for(i=0;i<libsprite->n_sprite;i++)
     {
        n_event=0;
        event=&libevent->sprite_event[i];
        while(event)
        {
           n_event++;
           event=event->next;
        }
 
        fwrite(&n_event, sizeof(unsigned int), 1, f);
 
        event=&libevent->sprite_event[i];
        while(event)
        {
          WriteEvent(f, event, bg_sound);
          event=event->next;
         }
     } /* !i<libsprite->n_sprite */
 
 
     free(bg_sound);
     fclose(f);
}
 
void WriteEvent(FILE *f, struct s_event *event, char *bg_sound)
{
  char buffer[256];
 
  if(!f) return;
  fwrite(&event->type, sizeof(enum e_event_type), 1, f);
  if(event->type==EVENT_NULL) return;
 
  fwrite(&event->onaction, sizeof(enum e_event_action), 1, f);
  fwrite(&event->proba, sizeof(unsigned char), 1, f);
  fwrite(&event->player_anim, sizeof(unsigned int), 1, f);
  fwrite(&event->is_unique, sizeof(unsigned char), 1, f);
 
  memset(&buffer,0,sizeof(buffer));
  strcpy(buffer,bg_sound);
  fwrite(&buffer,63,sizeof(char),f);
 
  switch(event->type)
  {
    case EVENT_NULL:
      break;
    case EVENT_TELEPORT:
      memset(&buffer,0,sizeof(buffer));
      if(((struct s_event_param_teleport*)event->param)->filename!=NULL)
        strcpy(buffer,((struct s_event_param_teleport*)event->param)->filename);
      fwrite(&buffer,63,sizeof(char),f);
 
      fwrite(&((struct s_event_param_teleport*)event->param)->startX, sizeof(unsigned int), 1, f);
      fwrite(&((struct s_event_param_teleport*)event->param)->startY, sizeof(unsigned int), 1, f);
      break;
    case EVENT_DIALOG:
      memset(&buffer,0,sizeof(buffer));
      if(((struct s_event_param_dialog*)event->param)->dialog!=NULL)
        strcpy(buffer,((struct s_event_param_dialog*)event->param)->dialog);
        fwrite(&buffer,255,sizeof(char),f);
      break;
    case EVENT_BATTLE:
      break;
    case EVENT_SHOP:
      break;
    case EVENT_INN:
      break;
  }
}
 
void EventStaticData(struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     GET_MAPEVENT(2,2,map,libevent).type=EVENT_DIALOG;
     GET_MAPEVENT(2,2,map,libevent).onaction=EVENT_ACTION_ONKEYPRESS;
     GET_MAPEVENT(2,2,map,libevent).proba=100;
     GET_MAPEVENT(2,2,map,libevent).player_anim=-1;
     GET_MAPEVENT(2,2,map,libevent).sound=NULL;
     GET_MAPEVENT(2,2,map,libevent).is_unique=1;
     GET_MAPEVENT(2,2,map,libevent).next=NULL;
     GET_MAPEVENT(2,2,map,libevent).param=malloc(sizeof(struct s_event_param_dialog));
     ((struct s_event_param_dialog*)GET_MAPEVENT(2,2,map,libevent).param)->dialog=(char*)strdup("Coffre fermé à clef...");
 
 
     GET_MAPEVENT(2,3,map,libevent).type=EVENT_TELEPORT;
     GET_MAPEVENT(2,3,map,libevent).onaction=EVENT_ACTION_ONKEYPRESS;
     GET_MAPEVENT(2,3,map,libevent).proba=100;
     GET_MAPEVENT(2,3,map,libevent).player_anim=-1;
     //GET_MAPEVENT(2,3,map,libevent).sound=FSOUND_Sample_Load(FSOUND_FREE,"son\\tornade.wav",FSOUND_NORMAL,0,0);
     GET_MAPEVENT(2,3,map,libevent).sound=NULL;
     GET_MAPEVENT(2,3,map,libevent).is_unique=0;
     GET_MAPEVENT(2,3,map,libevent).next=NULL;
     GET_MAPEVENT(2,3,map,libevent).param=malloc(sizeof(struct s_event_param_teleport));
     ((struct s_event_param_teleport*)GET_MAPEVENT(2,3,map,libevent).param)->filename=(char*)strdup("map\\empty");
     ((struct s_event_param_teleport*)GET_MAPEVENT(2,3,map,libevent).param)->startX=128;
     ((struct s_event_param_teleport*)GET_MAPEVENT(2,3,map,libevent).param)->startY=128;
 
     libevent->sprite_event[1].type=EVENT_TELEPORT;
     libevent->sprite_event[1].onaction=EVENT_ACTION_AUTO;
     libevent->sprite_event[1].proba=100;
     libevent->sprite_event[1].player_anim=-1;
     libevent->sprite_event[1].sound=NULL;
     libevent->sprite_event[1].is_unique=0;
     libevent->sprite_event[1].next=NULL;
     libevent->sprite_event[1].param=malloc(sizeof(struct s_event_param_teleport));
     ((struct s_event_param_teleport*)libevent->sprite_event[1].param)->filename=NULL;
     ((struct s_event_param_teleport*)libevent->sprite_event[1].param)->startX=128;
     ((struct s_event_param_teleport*)libevent->sprite_event[1].param)->startY=128;
 
}
 
 
/* Code spécifique à chaque événement */
void DoEventTeleport(struct s_event *event, struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     char *file_map, *file_sprite, *file_event;
     struct s_event_param_teleport *param;
     param=event->param;
     if(param->filename==NULL)
     {
        SpriteMove(&libsprite->sprites[0], param->startX, param->startY, map);
     } else {
        file_map=calloc(strlen(param->filename)+5,sizeof(char));
        strcpy(file_map,param->filename);
        strcat(file_map, ".map");
        file_sprite=calloc(strlen(param->filename)+8,sizeof(char));
        strcpy(file_sprite,param->filename);
        strcat(file_sprite, ".sprite");
        file_event=calloc(strlen(param->filename)+7,sizeof(char));
        strcpy(file_event,param->filename);
        strcat(file_event, ".event");
 
        FreeMap(map);
        FreeSprite(libsprite);
        FreeLibEvent(libevent,map,libsprite);
 
        LoadSprite(libsprite, file_sprite);
 
        LoadMap(map, file_map);
 
        LoadEvent(libevent,map,libsprite,file_event);
 
        free(file_map);
        free(file_sprite);
        free(file_event);
     }
}
 
void DoEventDialog(struct s_event *event, struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
     struct s_event_param_dialog *param;
     param=event->param;
 
     /* ne nous occupons pas du rendu à l'écran pour l'instant */
     printf("%s\n", param->dialog);
}
 
void DoEventBattle(struct s_event *event, struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
}
 
void DoEventShop(struct s_event *event, struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
}
 
void DoEventInn(struct s_event *event, struct s_lib_event *libevent, struct s_map *map, struct s_lib_sprite *libsprite)
{
}
