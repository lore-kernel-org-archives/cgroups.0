From: Greg Thelen <gthelen@google.com>
Subject: Re: 4.3-rc1 dirty page count underflow (cgroup-related?)
Date: Fri, 18 Sep 2015 01:31:20 -0700
Message-ID: <xr937fnonn6v.fsf@gthelen.mtv.corp.google.com>
References: <xr938u84ntrn.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:in-reply-to:date:message-id
         :mime-version:content-type;
        bh=vnQcPlhuh/mBVUIJ9Y86QGVjfv8ZvaIfAEn+nQKNThQ=;
        b=XTB5GfVgtZT7hlB1dYULq8KDU6rGO2DiyfGG2xAk9I9vjw9YVk2K99wp5PRBtywFy7
         qdN/02v/kvBttSWwwmVuTekYq0PskjuakBG1qT4wLR+zLYovocXUi7Y0ht+BmnOsA974
         rhVCQjeYWsAyiz9YY6zQznP2uX7DJNjaxp+IuXK9pgIB5Uay/4oxB1/YxOm0TIU4QLRq
         mmIuR4AY9w3NtoYm9sSRC57uvi7VeSJMXFUyYdvUO6/+AuydBx9D3A/k8NRESHx5UxFh
         vkC6GTARJgX2m6pqPmYua3IbLPZp596ooJidxY0sW8oUBelgE1W7BfEv2ppdD/JEjDUC
         sLNQ==
In-Reply-To: <xr938u84ntrn.fsf@gthelen.mtv.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>


Greg Thelen wrote:

> Dave Hansen wrote:
>
>> I've been seeing some strange behavior with 4.3-rc1 kernels on my Ubuntu
>> 14.04.3 system.  The system will run fine for a few hours, but suddenly
>> start becoming horribly I/O bound.  A compile of perf for instance takes
>> 20-30 minutes and the compile seems entirely I/O bound.  But, the SSD is
>> only seeing tens or hundreds of KB/s of writes.
>>
>> Looking at some writeback tracepoints shows it hitting
>> balance_dirty_pages() pretty hard with a pretty large number of dirty
>> pages. :)
>>
>>>               ld-27008 [000] ...1 88895.190770: balance_dirty_pages: bdi
>>> 8:0: limit=234545 setpoint=204851 dirty=18446744073709513951
>>> bdi_setpoint=184364 bdi_dirty=33 dirty_ratelimit=24 task_ratelimit=0
>>> dirtied=1 dirtied_pause=0 paused=0 pause=136 period=136 think=0
>>> cgroup=/user/1000.user/c2.session
>>
>> So something is underflowing dirty.
>>
>> I added the attached patch and got a warning pretty quickly, so this
>> looks pretty reproducible for me.
>>
>> I'm not 100% sure this is from the 4.3 merge window.  I was running the
>> 4.2-rcs, but they seemed to have their own issues.  Ubuntu seems to be
>> automatically creating some cgroups, so they're definitely in play here.
>>
>> Any ideas what is going on?
>>
>>> [   12.415472] ------------[ cut here ]------------
>>> [   12.415481] WARNING: CPU: 1 PID: 1684 at mm/page-writeback.c:2435 account_page_cleaned+0x101/0x110()
>>> [   12.415483] MEM_CGROUP_STAT_DIRTY bogus
>>> [   12.415484] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc iptable_filter ip_tables ebtable_nat ebtables x_tables dm_crypt cmac rfcomm bnep arc4 iwldvm mac80211 btusb snd_hda_codec_hdmi iwlwifi btrtl btbcm btintel snd_hda_codec_realtek snd_hda_codec_generic bluetooth snd_hda_intel snd_hda_codec cfg80211 snd_hwdep snd_hda_core intel_rapl iosf_mbi hid_logitech_hidpp x86_pkg_temp_thermal snd_pcm coretemp ghash_clmulni_intel thinkpad_acpi joydev snd_seq_midi snd_seq_midi_event snd_rawmidi nvram snd_seq snd_timer snd_seq_device wmi snd soundcore mac_hid lpc_ich aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk
 _helper cryptd kvm_intel kvm hid_logitech_dj sdhci_pci sdhci usbhid hid
>>> [   12.415538] CPU: 1 PID: 1684 Comm: indicator-keybo Not tainted 4.3.0-rc1-dirty #25
>>> [   12.415540] Hardware name: LENOVO 2325AR2/2325AR2, BIOS G2ETA4WW (2.64 ) 04/09/2015
>>> [   12.415542]  ffffffff81aa8172 ffff8800c926ba30 ffffffff8132e3e2 ffff8800c926ba78
>>> [   12.415544]  ffff8800c926ba68 ffffffff8105e386 ffffea000fca4700 ffff880409b96420
>>> [   12.415547]  ffff8803ef979490 ffff880403ff4800 0000000000000000 ffff8800c926bac8
>>> [   12.415550] Call Trace:
>>> [   12.415555]  [<ffffffff8132e3e2>] dump_stack+0x4b/0x69
>>> [   12.415560]  [<ffffffff8105e386>] warn_slowpath_common+0x86/0xc0
>>> [   12.415563]  [<ffffffff8105e40c>] warn_slowpath_fmt+0x4c/0x50
>>> [   12.415566]  [<ffffffff8115f951>] account_page_cleaned+0x101/0x110
>>> [   12.415568]  [<ffffffff8115fa1d>] cancel_dirty_page+0xbd/0xf0
>>> [   12.415571]  [<ffffffff811fc044>] try_to_free_buffers+0x94/0xb0
>>> [   12.415575]  [<ffffffff81296740>] jbd2_journal_try_to_free_buffers+0x100/0x130
>>> [   12.415578]  [<ffffffff812498b2>] ext4_releasepage+0x52/0xa0
>>> [   12.415582]  [<ffffffff81153765>] try_to_release_page+0x35/0x50
>>> [   12.415585]  [<ffffffff811fcc13>] block_invalidatepage+0x113/0x130
>>> [   12.415587]  [<ffffffff81249d5e>] ext4_invalidatepage+0x5e/0xb0
>>> [   12.415590]  [<ffffffff8124a6f0>] ext4_da_invalidatepage+0x40/0x310
>>> [   12.415593]  [<ffffffff81162b03>] truncate_inode_page+0x83/0x90
>>> [   12.415595]  [<ffffffff81162ce9>] truncate_inode_pages_range+0x199/0x730
>>> [   12.415598]  [<ffffffff8109c494>] ? __wake_up+0x44/0x50
>>> [   12.415600]  [<ffffffff812962ca>] ? jbd2_journal_stop+0x1ba/0x3b0
>>> [   12.415603]  [<ffffffff8125a754>] ? ext4_unlink+0x2f4/0x330
>>> [   12.415607]  [<ffffffff811eed3d>] ? __inode_wait_for_writeback+0x6d/0xc0
>>> [   12.415609]  [<ffffffff811632ec>] truncate_inode_pages_final+0x4c/0x60
>>> [   12.415612]  [<ffffffff81250736>] ext4_evict_inode+0x116/0x4c0
>>> [   12.415615]  [<ffffffff811e139c>] evict+0xbc/0x190
>>> [   12.415617]  [<ffffffff811e1d2d>] iput+0x17d/0x1e0
>>> [   12.415620]  [<ffffffff811d623b>] do_unlinkat+0x1ab/0x2b0
>>> [   12.415622]  [<ffffffff811d6cb6>] SyS_unlink+0x16/0x20
>>> [   12.415626]  [<ffffffff817d7f97>] entry_SYSCALL_64_fastpath+0x12/0x6a
>>> [   12.415628] ---[ end trace 6fba1ddd3d240e13 ]---
>>> [   12.418211] ------------[ cut here ]------------
>
> I'm not denying the issue, bug the WARNING splat isn't necessarily
> catching a problem.  The corresponding code comes from your debug patch:
> +		WARN_ONCE(__this_cpu_read(memcg->stat->count[MEM_CGROUP_STAT_DIRTY]) > (1UL<<30), "MEM_CGROUP_STAT_DIRTY bogus");
>
> This only checks a single cpu's counter, which can be negative.  The sum
> of all counters is what matters.
> Imagine:
> cpu1) dirty page: inc
> cpu2) clean page: dec
> The sum is properly zero, but cpu2 is -1, which will trigger the WARN.
>
> I'll look at the code and also see if I can reproduce the failure using
> mem_cgroup_read_stat() for all of the new WARNs.
>
> Did you notice if the global /proc/meminfo:Dirty count also underflowed?

Looks to be miscommunication between memcg dirty page accounting and
page migration.

From d6b62de5475f85ed4dabe7b6c6f0991339b9c0c7 Mon Sep 17 00:00:00 2001
From: Greg Thelen <gthelen@google.com>
Date: Fri, 18 Sep 2015 00:38:14 -0700
Subject: [PATCH] possible fix

Assume that newpage is dirty and charged to memcg.  So the memcg's dirty
page count was incremented for the page.  Migration's move_to_new_page()
indirectly calls migrate_page_copy(newpage, page), which decrements
page->mem_cgroup's dirty page count, but because newpage->mem_cgroup is
not yet set, __set_page_dirty_nobuffers() cannot reincrement the memcg
dirty page count.  Later move_to_new_page() calls mem_cgroup_migrate()
which finally sets newpage->mem_cgroup, but the dirty page count is
never reincremented, despite PG_dirty=1.  Time passes and
account_page_cleaned(newpage) is called which decrements a
non-incremented page->mem_cgroup dirty page count, causing underflow.

Because we're exchanging one dirty page for another, we might be able to
avoid decrementing and immediately reincrementing the memcg's dirty
count.

This is an alternative (ugly) fix which survives light testing.  It
temporarily sets up newpage's memcg so that __set_page_dirty_nobuffers()
can increment memcg's dirty page count.  I need to study this approach
more carefully before claiming it's a good fix.

Not-Yet-Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/migrate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index c3cb566af3e2..6268eb8b6fd5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -734,6 +734,11 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 	if (!trylock_page(newpage))
 		BUG();
 
+#ifdef CONFIG_MEMCG
+	VM_BUG_ON(newpage->mem_cgroup);
+	newpage->mem_cgroup = page->mem_cgroup;
+#endif
+
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
@@ -755,6 +760,10 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 	else
 		rc = fallback_migrate_page(mapping, newpage, page, mode);
 
+#ifdef CONFIG_MEMCG
+	newpage->mem_cgroup = NULL;
+#endif
+
 	if (rc != MIGRATEPAGE_SUCCESS) {
 		newpage->mapping = NULL;
 	} else {

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
