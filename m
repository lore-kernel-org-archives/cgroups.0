From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix comments with paths pointing to renamed or moved
 files.
Date: Wed, 22 May 2019 11:54:31 -0700
Message-ID: <8ae488765c8d441dbb444adaf89e59a2afa81298.camel@perches.com>
References: <20190521155430.14941-1-langspielplatte@black-mesa.xyz>
         <20190522183614.GD10003@amd>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522183614.GD10003@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Pavel Machek <pavel@ucw.cz>, Lukas Prause <langspielplatte@black-mesa.xyz>
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, will.deacon@arm.com, rjw@rjwysocki.net, len.brown@intel.com, rostedt@goodmis.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-pm@vger.kernel.org, Lennart Glauer <mail@lennart-glauer.de>

On Wed, 2019-05-22 at 20:36 +0200, Pavel Machek wrote:
> On Tue 2019-05-21 17:54:30, Lukas Prause wrote:
> > This patch corrects renamed or moved paths in comments.
> > 
> > Signed-off-by: Lukas Prause <langspielplatte@black-mesa.xyz>
> > Signed-off-by: Lennart Glauer <mail@lennart-glauer.de>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> > diff --git a/kernel/power/power.h b/kernel/power/power.h
> > index 9e58bdc8a562..5de8b0c7f657 100644
> > --- a/kernel/power/power.h
> > +++ b/kernel/power/power.h
> > @@ -182,7 +182,7 @@ extern int swsusp_unmark(void);
> >  #endif
> >  
> >  struct timeval;
> > -/* kernel/power/swsusp.c */
> > +/* kernel/power/hibernate.c */
> >  extern void swsusp_show_speed(ktime_t, ktime_t, unsigned int, char *);
> >  
> >  #ifdef CONFIG_SUSPEND

I think all of these markings should be removed instead.
Why are these useful?
It seems many of these filenames in power.h aren't correct anyway.

For instance power.h has:

   /* kernel/power/hibernate.c */
   extern int swsusp_check(void);
   extern void swsusp_free(void);
   extern int swsusp_read(unsigned int *flags_p);
   extern int swsusp_write(unsigned int flags);
   extern void swsusp_close(fmode_t);
   #ifdef CONFIG_SUSPEND
   extern int swsusp_unmark(void);
   #endif

but:

swsusp_check is in swap.c
swsusp_free is in snapshot.c
swsusp_read is in swap.c

etc...

Perhaps:
---
 kernel/power/power.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 9e58bdc8a562..52bcb72564e5 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -16,7 +16,6 @@ struct swsusp_info {
 } __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_HIBERNATION
-/* kernel/power/snapshot.c */
 extern void __init hibernate_reserved_size_init(void);
 extern void __init hibernate_image_size_init(void);
 
@@ -55,7 +54,6 @@ extern int hibernate_resume_nonboot_cpu_disable(void);
 
 asmlinkage int swsusp_save(void);
 
-/* kernel/power/hibernate.c */
 extern bool freezer_test_done;
 
 extern int hibernation_snapshot(int platform_mode);
@@ -63,7 +61,6 @@ extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
-/* kernel/power/snapshot.c */
 extern void enable_restore_image_protection(void);
 #else
 static inline void enable_restore_image_protection(void) {}
@@ -171,7 +168,6 @@ extern int swsusp_swap_in_use(void);
 #define SF_NOCOMPRESS_MODE	2
 #define SF_CRC32_MODE	        4
 
-/* kernel/power/hibernate.c */
 extern int swsusp_check(void);
 extern void swsusp_free(void);
 extern int swsusp_read(unsigned int *flags_p);
@@ -182,11 +178,9 @@ extern int swsusp_unmark(void);
 #endif
 
 struct timeval;
-/* kernel/power/swsusp.c */
 extern void swsusp_show_speed(ktime_t, ktime_t, unsigned int, char *);
 
 #ifdef CONFIG_SUSPEND
-/* kernel/power/suspend.c */
 extern const char * const pm_labels[];
 extern const char *pm_states[];
 extern const char *mem_sleep_states[];
@@ -202,7 +196,6 @@ static inline int suspend_devices_and_enter(suspend_state_t state)
 #endif /* !CONFIG_SUSPEND */
 
 #ifdef CONFIG_PM_TEST_SUSPEND
-/* kernel/power/suspend_test.c */
 extern void suspend_test_start(void);
 extern void suspend_test_finish(const char *label);
 #else /* !CONFIG_PM_TEST_SUSPEND */
@@ -211,7 +204,6 @@ static inline void suspend_test_finish(const char *label) {}
 #endif /* !CONFIG_PM_TEST_SUSPEND */
 
 #ifdef CONFIG_PM_SLEEP
-/* kernel/power/main.c */
 extern int __pm_notifier_call_chain(unsigned long val, int nr_to_call,
 				    int *nr_calls);
 extern int pm_notifier_call_chain(unsigned long val);
@@ -289,7 +281,6 @@ static inline void suspend_thaw_processes(void)
 
 #ifdef CONFIG_PM_AUTOSLEEP
 
-/* kernel/power/autosleep.c */
 extern int pm_autosleep_init(void);
 extern int pm_autosleep_lock(void);
 extern void pm_autosleep_unlock(void);
@@ -307,7 +298,6 @@ static inline suspend_state_t pm_autosleep_state(void) { return PM_SUSPEND_ON; }
 
 #ifdef CONFIG_PM_WAKELOCKS
 
-/* kernel/power/wakelock.c */
 extern ssize_t pm_show_wakelocks(char *buf, bool show_active);
 extern int pm_wake_lock(const char *buf);
 extern int pm_wake_unlock(const char *buf);


