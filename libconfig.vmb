#ifndef LIBCONFIG_H
#define LIBCONFIG_H

#ifdef WIN32
#pragma warning(disable : 4996)
#endif

/* define this if you need a local copy of mem_tetra ll */
#define MMIX_LOCAL_LL  /* mem_tetra *ll; current place in the simulated memory */

#define MMIX_STO(val,addr) store_data(8,val,addr)
#define MMIX_STT(val,addr) store_data(4,val,addr)
#define MMIX_STW(val,addr) store_data(2,val,addr)
#define MMIX_STB(val,addr) store_data(1,val,addr)

#define MMIX_LDO(val,addr)  load_data(8,&(val),addr,0)
#define MMIX_LDT(val,addr)  load_data(4,&(val),addr,0)
#define MMIX_LDW(val,addr)  load_data(2,&(val),addr,0)
#define MMIX_LDB(val,addr)  load_data(1,&(val),addr,0)

#define MMIX_STO_UNCACHED(val,addr) store_data_uncached(8,val,addr) 
#define MMIX_LDO_UNCACHED(val,addr) load_data_uncached(8,&(val),addr,0)


#define MMIX_FETCH(inst,loc) load_instruction(&inst,loc)
#define MMIX_STORE_IVTC(virt,phys) store_exec_translation(&(virt),&(phys))
#define MMIX_STORE_DVTC(virt,phys) store_data_translation(&(virt),&(phys))

#define	MMIX_DELAY(ms,d)  d = vmb_wait_for_event_timed(&vmb,ms)

/* define this to check for external asynchronous ineterrupts*/
#define MMIX_GET_INTERRUPT  \
if (vmb_get_interrupt(&vmb,&new_Q.h,&new_Q.l)==1) \
  { g[rQ].h |= new_Q.h; g[rQ].l |= new_Q.l; }

/* this code is executed when MMIX enters the handler for Ctrl-C */
#define   MMIX_CTRL_HANDLER   vmb_cancel_wait_for_event(&vmb); show_operating_system=true;


/* this code defines additional command line options */
#define MMIX_OPTIONS  \
 case 'B': \
  { char *p; \
    p = strchr(arg+1,':'); \
    if (p==NULL) \
    { host=localhost; \
      port = atoi(arg+1); \
    }    \
    else \
    { port = atoi(p+1); \
      host = malloc(p+1-arg+1); \
      if (host==NULL) panic("No room for hostname"); \
      strncpy(host,arg+1,p-arg-1); \
      host[p-arg-1]=0; \
    } \
  } \
  return;  \


/* if MMIX_BOOT is defined, mmis-sim will boot from addres #8000...0000
   otherwise it will resume at Main */
#define MMIX_BOOT

#undef MMIX_PRINT

#ifdef MMIX_PRINT
extern int mmix_printf(char *format,...);
extern int mmix_fputc(int c, FILE *f);
#define printf(...) mmix_printf(__VA_ARGS__)
#define fprintf(file,...) mmix_printf(__VA_ARGS__)
#define fputc(c,f) mmix_fputc(c,f)
#endif

/* this action is executed when ther is no mmo file on the command line */
#define MMIX_NO_FILE


/* define this to get the real TRAP implementation not the MMIXWARE fake TRAPS */
#define MMIX_TRAP

/* this is the error display function */
#define MMIX_ERROR(f,m) fprintf(stderr,f,m)

/* define this if you need the tetra inside the mem_node */
#define MMIX_MEM_TET /* tetra tet; the tetrabyte of simulated memory */

/* these are the functions for the instructions not implemented in the basic mmix simulator */
#define MMIX_WRITE_DCACHE() write_all_data_cache()
#define MMIX_CLEAR_ICACHE() clear_all_instruction_cache()
#define MMIX_CLEAR_DCACHE() clear_all_data_cache()
#define MMIX_UPDATE_VTC(w) update_vtc(w)
#define MMIX_CLEAR_DVTC() clear_all_data_vtc()
#define MMIX_CLEAR_IVTC() clear_all_instruction_vtc()
#define MMIX_PRELOAD_DCACHE(w,xx) preload_data_cache(w,xx)
#define MMIX_PRELOAD_ICACHE(w,xx) prego_instruction(w,xx)
#define MMIX_STORE_DCACHE(w,xx) write_data(w,xx)
#define MMIX_DELETE_DCACHE(w,xx) delete_data(w,xx)
#define MMIX_DELETE_ICACHE(w,xx) delete_instruction(w,xx)

#define MMXIAL_LINE_TRUNCATED     fprintf(stderr,"(say `-b <number>' to increase the length of my input buffer)\n");

/* MMIXAL has its own notion of file numbers as embedded in the mmo file
   we might want to convert this to a global file number */
#define MMIX_FILE_NO(file_no) (file_no)

/* define this to record file line and location associations while assembling */
#define MMIXAL_LINE_LOC(file_no,line_no,cur_loc)

#endif
