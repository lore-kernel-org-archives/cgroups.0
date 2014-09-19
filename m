From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Racy manipulation of task_struct->flags in cgroups code causes hard to reproduce kernel panics
Date: Fri, 19 Sep 2014 20:53:33 +0900
Message-ID: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

A user is experiencing kernel panic described at
https://access.redhat.com/solutions/640843 . It turned out that the
root cause seems to be a race condition between clear_used_math() and
cpuset_attach_task(). I'm reporting this problem here because this race
condition remains in current upstream kernel.

First I explain this problem using RHEL6's 2.6.32-358.23.2.el6.x86_64
kernel, and then I explain this problem using current upstream kernel.

When executing an ELF program, load_elf_binary() is called by
search_binary_handler() called by do_execve() called by sys_execve()
called by stub_execve().

Inside load_elf_binary(), flush_old_exec() is called when the control
reaches the point of no return, and start_thread() is called just before
successfully leaving load_elf_binary().

---------- linux-2.6.32-358.23.2.el6/fs/binfmt_elf.c ----------
564:static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
565:{
(...snipped...)
719:
720:    /* Flush all traces of the currently running executable */
721:    retval = flush_old_exec(bprm);
722:    if (retval)
723:            goto out_free_dentry;
724:
725:#ifdef CONFIG_X86_32
726:    /*
727:     * Turn off the CS limit completely if exec-shield disabled or
728:     * NX active:
729:     */
730:    if (!exec_shield || executable_stack != EXSTACK_DISABLE_X || nx_enabled)
731:            arch_add_exec_range(current->mm, -1);
732:#endif
733:
734:    /* OK, This is the point of no return */
735:    current->flags &= ~PF_FORKNOEXEC;
736:    current->mm->def_flags = def_flags;
737:
(...snipped...)
993:
994:    start_thread(regs, elf_entry, bprm->p);
995:    retval = 0;
996:out:
997:    kfree(loc);
998:out_ret:
999:    return retval;
1000:
1001:   /* error cleanup */
1002:out_free_dentry:
1003:   allow_write_access(interpreter);
1004:   if (interpreter)
1005:           fput(interpreter);
1006:out_free_interp:
1007:   kfree(elf_interpreter);
1008:out_free_ph:
1009:   kfree(elf_phdata);
1010:   goto out;
1011:}
---------- linux-2.6.32-358.23.2.el6/fs/binfmt_elf.c ----------

Inside flush_old_exec(), flush_thread() is called.

---------- linux-2.6.32-358.23.2.el6/fs/exec.c ----------
1010:int flush_old_exec(struct linux_binprm * bprm)
1011:{
1012:   int retval;
1013:
1014:   /*
1015:    * Make sure we have a private signal table and that
1016:    * we are unassociated from the previous thread group.
1017:    */
1018:   retval = de_thread(current);
1019:   if (retval)
1020:           goto out;
1021:
1022:   set_mm_exe_file(bprm->mm, bprm->file);
1023:
1024:   /*
1025:    * Release all of the old mmap stuff
1026:    */
1027:   acct_arg_size(bprm, 0);
1028:   retval = exec_mmap(bprm->mm);
1029:   if (retval)
1030:           goto out;
1031:
1032:   bprm->mm = NULL;                /* We're using it now */
1033:
1034:   current->flags &= ~PF_RANDOMIZE;
1035:   flush_thread();
1036:   current->personality &= ~bprm->per_clear;
1037:
1038:   return 0;
1039:
1040:out:
1041:   return retval;
1042:}
---------- linux-2.6.32-358.23.2.el6/fs/exec.c ----------

Inside flush_old_exec(), clear_used_math() which removes PF_USED_MATH from
current->flags is called.

---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/process.c ----------
116:void flush_thread(void)
117:{
118:    struct task_struct *tsk = current;
119:
120:    clear_tsk_thread_flag(tsk, TIF_DEBUG);
121:
122:    tsk->thread.debugreg0 = 0;
123:    tsk->thread.debugreg1 = 0;
124:    tsk->thread.debugreg2 = 0;
125:    tsk->thread.debugreg3 = 0;
126:    tsk->thread.debugreg6 = 0;
127:    tsk->thread.debugreg7 = 0;
128:    memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
129:    /*
130:     * Forget coprocessor state..
131:     */
132:    tsk->fpu_counter = 0;
133:    clear_fpu(tsk);
134:    clear_used_math();
135:}
---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/process.c ----------

Inside start_thread(), free_thread_xstate() which sets
current->thread.xstate to NULL is called.

---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/process_64.c ----------
325:void
326:start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
327:{
328:    loadsegment(fs, 0);
329:    loadsegment(es, 0);
330:    loadsegment(ds, 0);
331:    load_gs_index(0);
332:    regs->ip                = new_ip;
333:    regs->sp                = new_sp;
334:    percpu_write(old_rsp, new_sp);
335:    regs->cs                = __USER_CS;
336:    regs->ss                = __USER_DS;
337:    regs->flags             = 0x200;
338:    set_fs(USER_DS);
339:    /*
340:     * Free the old FP and other extended state
341:     */
342:    free_thread_xstate(current);
343:}
---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/process_64.c ----------

---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/process.c ----------
47:void free_thread_xstate(struct task_struct *tsk)
48:{
49:     fpu_free((struct fpu *)&tsk->thread.xstate);
50:}
---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/process.c ----------

---------- linux-2.6.32-358.23.2.el6/arch/x86/include/asm/i387.h ----------
486:static inline void fpu_free(struct fpu *fpu)
487:{
488:    if (fpu->state) {
489:            kmem_cache_free(task_xstate_cachep, fpu->state);
490:            fpu->state = NULL;
491:    }
492:}
---------- linux-2.6.32-358.23.2.el6/arch/x86/include/asm/i387.h ----------

Therefore, it is expected that current->flags does not contain
PF_USED_MATH and current->thread.xstate is NULL when successfully
leaving load_elf_binary().

Then, upon first execution of instruction which uses fpu after
successfully returning from execve(), math_state_restore() is called by
do_device_not_available() called by device_not_available().

---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/traps.c ----------
886:/*
887: * __math_state_restore assumes that cr0.TS is already clear and the
888: * fpu state is all ready for use.  Used during context switch.
889: */
890:void __math_state_restore(void)
891:{
892:    struct thread_info *thread = current_thread_info();
893:    struct task_struct *tsk = thread->task;
894:
895:    /*
896:     * Paranoid restore. send a SIGSEGV if we fail to restore the state.
897:     */
898:    if (unlikely(restore_fpu_checking(tsk))) {
899:            stts();
900:            force_sig(SIGSEGV, tsk);
901:            return;
902:    }
903:
904:    thread->status |= TS_USEDFPU;   /* So we fnsave on switch_to() */
905:    tsk->fpu_counter++;
906:}
907:
908:/*
909: * 'math_state_restore()' saves the current math information in the
910: * old math state array, and gets the new ones from the current task
911: *
912: * Careful.. There are problems with IBM-designed IRQ13 behaviour.
913: * Don't touch unless you *really* know how it works.
914: *
915: * Must be called with kernel preemption disabled (in this case,
916: * local interrupts are disabled at the call-site in entry.S).
917: */
918:asmlinkage void math_state_restore(void)
919:{
920:    struct thread_info *thread = current_thread_info();
921:    struct task_struct *tsk = thread->task;
922:
923:    if (!tsk_used_math(tsk)) {
924:            local_irq_enable();
925:            /*
926:             * does a slab alloc which can sleep
927:             */
928:            if (init_fpu(tsk)) {
929:                    /*
930:                     * ran out of memory!
931:                     */
932:                    do_group_exit(SIGKILL);
933:                    return;
934:            }
935:            local_irq_disable();
936:    }
937:
938:    clts();                         /* Allow maths ops (or we recurse) */
939:
940:    __math_state_restore();
941:}
(...snipped...)
955:dotraplinkage void __kprobes
956:do_device_not_available(struct pt_regs *regs, long error_code)
957:{
958:#ifdef CONFIG_X86_32
959:    if (read_cr0() & X86_CR0_EM) {
960:            struct math_emu_info info = { };
961:
962:            conditional_sti(regs);
963:
964:            info.regs = regs;
965:            math_emulate(&info);
966:    } else {
967:            math_state_restore(); /* interrupts still off */
968:            conditional_sti(regs);
969:    }
970:#else
971:    math_state_restore();
972:#endif
973:}
---------- linux-2.6.32-358.23.2.el6/arch/x86/kernel/traps.c ----------

Inside math_state_restore(), it is expected that tsk_used_math(tsk) is 0
because current->flags does not contain PF_USED_MATH.

The user did a SystemTap probe, and surprisingly current->flags contained
PF_USED_MATH while current->thread.xstate is NULL when leaving
start_thread().

The user did another SystemTap probe, and found that current->flags
contains PF_USED_MATH as soon as returning from flush_old_exec().
This probe result suggests that PF_USED_MATH was not removed by
clear_used_math() called by flush_old_exec().

---------- objdump of clear_used_math() ----------
ffffffff81014207:       81 60 14 ff df ff ff    andl   $0xffffdfff,0x14(%rax)
---------- objdump of clear_used_math() ----------

When PF_USED_MATH was not removed by clear_used_math() called by
flush_old_exec(), tsk_used_math(tsk) inside math_state_restore() is not 0
and __math_state_restore() is called with current->thread.xstate == NULL .

Inside __math_state_restore(), restore_fpu_checking() detects that
current->thread.xstate is bad and returns an error, thus SIGSEGV is
sent to current thread.

----------
# stap -e 'probe kernel.function("__send_signal") { if ($sig == 11) print_backtrace(); }'
 0xffffffff81086d10 : __send_signal+0x0/0x390 [kernel]
 0xffffffff810870e2 : send_signal+0x42/0x80 [kernel]
 0xffffffff81088339 : force_sig_info+0x89/0x110 [kernel]
 0xffffffff810883d6 : force_sig+0x16/0x20 [kernel]
 0xffffffff8100c48c : __math_state_restore+0x8c/0x90 [kernel]        /* arch/x86/kernel/traps.c:901 */
 0xffffffff8100c535 : math_state_restore+0x45/0x60 [kernel]          /* arch/x86/kernel/traps.c:941 */
 0xffffffff815112de : do_device_not_available+0xe/0x10 [kernel]      /* arch/x86/kernel/traps.c:973 */
 0xffffffff8100be7b : device_not_available+0x1b/0x20 [kernel]        /* arch/x86/kernel/entry_64.S:1120 */
----------

Unfortunately, when xfpregs_get() is called by elf_core_dump() called by
do_coredump() called by get_signal_to_deliver() called by do_signal()
called by do_notify_resume() called by retint_signal() due to SIGSEGV
sent from __math_state_restore(), current->thread.xstate remains NULL.

Thus init_fpu() called by xfpregs_get() returns 0 without setting
current->thread.xstate to non NULL because current->flags contains
PF_USED_MATH. And then memset() is called by user_regset_copyout()
called by xfpregs_get(), and finally triggers NULL pointer dereference.

Then, what made current->flags to unexpectedly preserve PF_USED_MATH flag?
The user is running cgrulesengd process in order to utilize cpuset cgroup.
Thus, cpuset_update_task_spread_flag() is called when cgrulesengd process
writes someone's pid to /cgroup/cpuset/$group/tasks interface.

cpuset_update_task_spread_flag() is updating other thread's
"struct task_struct"->flags without exclusion control or atomic
operations!

---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
300:/*
301: * update task's spread flag if cpuset's page/slab spread flag is set
302: *
303: * Called with callback_mutex/cgroup_mutex held
304: */
305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
306:                                    struct task_struct *tsk)
307:{
308:    if (is_spread_page(cs))
309:            tsk->flags |= PF_SPREAD_PAGE;
310:    else
311:            tsk->flags &= ~PF_SPREAD_PAGE;
312:    if (is_spread_slab(cs))
313:            tsk->flags |= PF_SPREAD_SLAB;
314:    else
315:            tsk->flags &= ~PF_SPREAD_SLAB;
316:}
(...snipped...)
1406:/* Per-thread attachment work. */
1407:static void cpuset_attach_task(struct cgroup *cont, struct task_struct *tsk)
1408:{
1409:   int err;
1410:   struct cpuset *cs = cgroup_cs(cont);
1411:
1412:   /*
1413:    * can_attach beforehand should guarantee that this doesn't fail.
1414:    * TODO: have a better way to handle failure here
1415:    */
1416:   err = set_cpus_allowed_ptr(tsk, cpus_attach);
1417:   WARN_ON_ONCE(err);
1418:
1419:   cpuset_change_task_nodemask(tsk, &cpuset_attach_nodemask_to);
1420:   cpuset_update_task_spread_flag(cs, tsk);
1421:}
---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------

---------- objdump of cpuset_update_task_spread_flag() ----------
static void cpuset_update_task_spread_flag(struct cpuset *cs,
                                        struct task_struct *tsk)
{
        if (is_spread_page(cs))
ffffffff810cb415:       41 f6 44 24 20 20       testb  $0x20,0x20(%r12)
ffffffff810cb41b:       74 23                   je     ffffffff810cb440 <cpuset_attach_task+0x60>
                tsk->flags |= PF_SPREAD_PAGE;
ffffffff810cb41d:       8b 43 14                mov    0x14(%rbx),%eax
ffffffff810cb420:       0d 00 00 00 01          or     $0x1000000,%eax
ffffffff810cb425:       89 43 14                mov    %eax,0x14(%rbx)
        else
                tsk->flags &= ~PF_SPREAD_PAGE;
        if (is_spread_slab(cs))
ffffffff810cb428:       41 f6 44 24 20 40       testb  $0x40,0x20(%r12)
ffffffff810cb42e:       75 23                   jne    ffffffff810cb453 <cpuset_attach_task+0x73>
                tsk->flags |= PF_SPREAD_SLAB;
        else
                tsk->flags &= ~PF_SPREAD_SLAB;
ffffffff810cb430:       25 ff ff ff fd          and    $0xfdffffff,%eax
ffffffff810cb435:       89 43 14                mov    %eax,0x14(%rbx)
        err = set_cpus_allowed_ptr(tsk, cpus_attach);
        WARN_ON_ONCE(err);

        cpuset_change_task_nodemask(tsk, &cpuset_attach_nodemask_to);
        cpuset_update_task_spread_flag(cs, tsk);
}
ffffffff810cb438:       5b                      pop    %rbx
ffffffff810cb439:       41 5c                   pop    %r12
ffffffff810cb43b:       c9                      leaveq
ffffffff810cb43c:       c3                      retq
ffffffff810cb43d:       0f 1f 00                nopl   (%rax)
                                        struct task_struct *tsk)
{
        if (is_spread_page(cs))
                tsk->flags |= PF_SPREAD_PAGE;
        else
                tsk->flags &= ~PF_SPREAD_PAGE;
ffffffff810cb440:       8b 43 14                mov    0x14(%rbx),%eax
ffffffff810cb443:       25 ff ff ff fe          and    $0xfeffffff,%eax
ffffffff810cb448:       89 43 14                mov    %eax,0x14(%rbx)
        if (is_spread_slab(cs))
ffffffff810cb44b:       41 f6 44 24 20 40       testb  $0x40,0x20(%r12)
ffffffff810cb451:       74 dd                   je     ffffffff810cb430 <cpuset_attach_task+0x50>
                tsk->flags |= PF_SPREAD_SLAB;
ffffffff810cb453:       0d 00 00 00 02          or     $0x2000000,%eax
ffffffff810cb458:       89 43 14                mov    %eax,0x14(%rbx)
        err = set_cpus_allowed_ptr(tsk, cpus_attach);
        WARN_ON_ONCE(err);

        cpuset_change_task_nodemask(tsk, &cpuset_attach_nodemask_to);
        cpuset_update_task_spread_flag(cs, tsk);
}
ffffffff810cb45b:       5b                      pop    %rbx
ffffffff810cb45c:       41 5c                   pop    %r12
ffffffff810cb45e:       c9                      leaveq
ffffffff810cb45f:       c3                      retq
---------- objdump of cpuset_update_task_spread_flag() ----------

This means that the effect of clear_used_math() called by flush_thread()
called by flush_old_exec() will be cancelled if concurrently executed.

To emulate this race condition, you can try

  # ulimit -c unlimited; su -c "echo hello"

while running a SystemTap probe

  # stap -g -e 'probe kernel.function("flush_thread").return { if (execname() == "su") { %{ current->flags |= PF_USED_MATH %}; exit(); } }'

which purposely sets PF_USED_MATH flag to current->flags after
clear_used_math() is called.


Next, I explain this problem using current upstream kernel.
This problem in current kernel is conditional and the location of
NULL pointer dereference is different than RHEL6. But we need to fix
this race condition anyway because the NULL pointer dereference shown
below is nothing but one of possible failures.

If use_eager_fpu() is false (e.g. eagerfpu=off kernel boot option is used),
clear_used_math() is called by drop_fpu() called by drop_init_fpu() called by
flush_thread(). Thus, racing with cpuset_update_task_spread_flag() makes
the same result with RHEL6.

When math_state_restore() is called after the race condition,
tsk_used_math(current) is not 0 and thus init_fpu(current) is not called.

----------
void math_state_restore(void)
{
        struct task_struct *tsk = current;

        if (!tsk_used_math(tsk)) {
                local_irq_enable();
                /*
                 * does a slab alloc which can sleep
                 */
                if (init_fpu(tsk)) {
                        /*
                         * ran out of memory!
                         */
                        do_group_exit(SIGKILL);
                        return;
                }
                local_irq_disable();
        }

        __thread_fpu_begin(tsk);

        /*
         * Paranoid restore. send a SIGSEGV if we fail to restore the state.
         */
        if (unlikely(restore_fpu_checking(tsk))) {
                drop_init_fpu(tsk);
                force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
                return;
        }

        tsk->thread.fpu_counter++;
}
----------

Then, restore_fpu_checking() is called with current->thread.xstate == NULL,
resulting in NULL pointer dereference.

----------
[   47.144887] BUG: unable to handle kernel NULL pointer dereference at 000000000000033f
[   47.149085] IP: [<ffffffff81002fab>] math_state_restore+0x6b/0x190
[   47.152288] PGD 7c918067 PUD 7ccd0067 PMD 0
[   47.154752] Oops: 0000 [#1] SMP
[   47.156626] Modules linked in: fuse ipv6 vhost_net macvtap macvlan vhost tun ppdev snd_ens1371 snd_rawmidi snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm dm_mod snd_timer snd soundcore sg i2c_piix4 parport_pc parport shpchp ext4(E) jbd2(E) mbcache(E) crc16(E) sd_mod(E) crc_t10dif(E)
sr_mod(E) cdrom(E) vmxnet3(E) mptspi(E) mptscsih(E) mptbase(E) scsi_transport_spi(E) pata_acpi(E) ata_generic(E) ata_piix(E)
[   47.177131] CPU: 0 PID: 2127 Comm: bash Tainted: G            E  3.17.0-rc5-00025-g8ba4caf-dirty #422
[   47.179355] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[   47.181971] task: ffff88007c3f17e0 ti: ffff88007c434000 task.ti: ffff88007c434000
[   47.183793] RIP: 0010:[<ffffffff81002fab>]  [<ffffffff81002fab>] math_state_restore+0x6b/0x190
[   47.185907] RSP: 0000:ffff88007c437f48  EFLAGS: 00010002
[   47.187184] RAX: 00000000ffffffff RBX: ffff88007c3f17e0 RCX: 00007f46cb929000
[   47.188908] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: 0000000000000000
[   47.190874] RBP: 00007fffdafb28a0 R08: 00000000ffffffff R09: 0000000000000000
[   47.192594] R10: 0000000000000022 R11: 00000032bd81a240 R12: 00000032bda21c08
[   47.194282] R13: 0000000000000050 R14: 00000032bda21b88 R15: 000000000000000f
[   47.195970] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[   47.197973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   47.199397] CR2: 000000000000033f CR3: 000000007c819000 CR4: 00000000000407f0
[   47.201152] Stack:
[   47.201669]  0000000000000000 ffffffff81505908 000000000000000f 00000032bda21b88
[   47.203661]  0000000000000050 00000032bda21c08 00007fffdafb28a0 0000000000000000
[   47.205644]  00000032bd81a240 0000000000000022 0000000000000000 00000000ffffffff
[   47.207581] Call Trace:
[   47.208200]  [<ffffffff81505908>] ? device_not_available+0x18/0x20
[   47.209656] Code: b8 00 00 e9 10 00 00 00 db e2 0f 77 db 83 54 05 00 00 66 0f 1f 44 00 00 66 66 90 66 90 b8 ff ff ff ff 48 8b bb 58 05 00 00 89 c2 <48> 0f ae 2f 31 c0 85 c0 75 5e 80 83 74 05 00 00 01 5b c3 66 90
[   47.217037] RIP  [<ffffffff81002fab>] math_state_restore+0x6b/0x190
[   47.218618]  RSP <ffff88007c437f48>
[   47.219484] CR2: 000000000000033f
[   47.220328] ---[ end trace d8c4c7e7f669cd59 ]---
----------


So, we need to somehow fix this race condition.
(Also, __math_state_restore() needs to be fixed in order to avoid
calling xfpregs_get() when current->thread.xstate == NULL ?)
