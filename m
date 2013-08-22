From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: OOPS in cfq/blkcgroups if CFQ_GROUP_IOSCHED is not set
Date: Wed, 21 Aug 2013 22:05:58 -0700
Message-ID: <CAOMFOmV-k_0RxNwY2JEXn9sHmsoJYArWwURNj1-Srph=FzbFUQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=tyT1RPkk3LBUIL6o5wPh7uwcPBHonesfy8V69exlLuc=;
        b=c0ZyMOy/dIuf4D6KE0uGH2i0anIOpRRAa4+HMl+q87s+4OEZKUFn4/C0eaPOpb7+8p
         BZ8iiQ34DBmWKHXOYHsKUUJ/jZ1Ag3iJZlW1XxcrfFCnsHZXphxfhxLpB8ZhU2UzrF1s
         A0279H6mtl7DTB8n5Go+Mo9ogUk/yKBeQ0SOmWlEK1x+MXAntZ7eNI9ZSgy66SLzdHcA
         d/jhMcXJk4RDVm/IDAc1BmWUozeO93H02UMzeDoxlPQoGUG8glNSM80H5GCy7qtO0UPu
         MVcwsxEPUdXnDcomABNP/5F1a0h0rJonmqAeXUWL9EIUPpD3oqWMHz6cOxgEy6+gZHY2
         5M9Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi,

Running our iscsi stress tests on 3.11-rc kernel I've got an oops (see
it below).


After debugging it I think I understand what is the problem. It is in
CFQ if CFQ_GROUP_IOSCHED is not set. If the config option is not set
then following function is never called from cfq-iosched.c:

blkcg_activate_policy(q, &blkcg_policy_cfq);

And this function is important for blockcg because it sets root_blkg:

q->root_blkg = blkg;

If root_blkg is not set then it is NULL and later it confuses function
__blk_queue_next_rl that has following check:

if (ent == &q->root_blkg->q_node)

it intends to skip unintialized request list structures that
correspond to root_blkg cgroup. But because q->root_blkg is NULL the
code fails to filter it out and returns invalid requests_list back to
the user. The caller tries to use unintialized spinlock and crashes.


In crash codepath ent is indeed points to root cgroup - adding

        if (ent == &q->blkg_list)
                return NULL;

        blkg = container_of(ent, struct blkcg_gq, q_node);
+       BUG_ON(blkg->blkcg == &blkcg_root);
        return &blkg->rl;

crashes kernel earlier (IMHO this check is useful and worth adding to the code).



Turning CFQ_GROUP_IOSCHED makes the crash go away.

[  498.876699] BUG: unable to handle kernel NULL pointer dereference
at           (null)
    [  498.884566] IP: [<ffffffff810c58cb>] __wake_up_common+0x2b/0x90
    [  498.890510] PGD 60f7a9067 PUD 60f4c9067 PMD 0
    [  498.895028] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
    [  498.899943] gsmi: Log Shutdown Reason 0x03
    [  498.904037] Modules linked in: act_mirred cls_tcindex
cls_prioshift sch_dsmark xt_multiport iptable_mangle sata_mv elephant
elephant_dev_num cdc_acm uhci_hcd ehci_hcd i2c_d
    [  498.924787] CPU: 9 PID: 41382 Comm: iSCSI-write- Not tainted
3.11.0-dbg-DEV #19
    [  498.932095] Hardware name: Intel XXX
    [  498.939400] task: ffff88060d16eec0 ti: ffff88060d170000
task.ti: ffff88060d170000
    [  498.946883] RIP: 0010:[<ffffffff810c58cb>]
[<ffffffff810c58cb>] __wake_up_common+0x2b/0x90
    [  498.955252] RSP: 0000:ffff88060d171818  EFLAGS: 00010096
    [  498.960569] RAX: 0000000000000082 RBX: ffff880baa3dee60 RCX:
0000000000000000
    [  498.967708] RDX: 0000000000000000 RSI: 0000000000000003 RDI:
ffff880baa3dee60
    [  498.974845] RBP: ffff88060d171858 R08: 0000000000000000 R09:
0000000000000000
    [  498.981983] R10: 0000000000000000 R11: 0000000000000002 R12:
ffff880baa3dee98
    [  498.989121] R13: 0000000000000003 R14: 0000000000000000 R15:
0000000000000003
    [  498.996261] FS:  00007f977cba6700(0000)
GS:ffff880c79c60000(0000) knlGS:0000000000000000
    [  499.004351] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [  499.010102] CR2: 0000000000000000 CR3: 000000060f7a5000 CR4:
00000000000007e0
    [  499.017238] Stack:
    [  499.019258]  0000000000000082 0000000000000000 ffff88060d171858
ffff880baa3dee60
    [  499.026752]  0000000000000082 0000000000000003 0000000000000000
0000000000000000
    [  499.034254]  ffff88060d171898 ffffffff810c7848 ffff88060d171888
ffff880bde4bc4b8
    [  499.041748] Call Trace:
    [  499.044207]  [<ffffffff810c7848>] __wake_up+0x48/0x70
    [  499.049263]  [<ffffffff8131da53>] __blk_drain_queue+0x123/0x190
    [  499.055187]  [<ffffffff8131dbb5>] blk_cleanup_queue+0xf5/0x210
    [  499.061023]  [<ffffffff8141877a>] __scsi_remove_device+0x5a/0xd0
    [  499.067034]  [<ffffffff81418824>] scsi_remove_device+0x34/0x50
    [  499.072873]  [<ffffffff814189cb>] scsi_remove_target+0x16b/0x220
    [  499.078882]  [<ffffffff814210f1>] __iscsi_unbind_session+0xd1/0x1b0
    [  499.085153]  [<ffffffff814212b2>] iscsi_remove_session+0xe2/0x1c0
    [  499.091249]  [<ffffffff814213a6>] iscsi_destroy_session+0x16/0x60
    [  499.097347]  [<ffffffff81423a59>] iscsi_session_teardown+0xd9/0x100
    [  499.103618]  [<ffffffff8142b75a>] iscsi_sw_tcp_session_destroy+0x5a/0xb0
    [  499.110319]  [<ffffffff81420948>] iscsi_if_rx+0x10e8/0x1560
    [  499.115899]  [<ffffffff81573335>] netlink_unicast+0x145/0x200
    [  499.121647]  [<ffffffff815736f3>] netlink_sendmsg+0x303/0x410
    [  499.127396]  [<ffffffff81528196>] sock_sendmsg+0xa6/0xd0
    [  499.132713]  [<ffffffff815294bc>] ___sys_sendmsg+0x38c/0x3a0
    [  499.138376]  [<ffffffff811ea840>] ? fget_light+0x40/0x160
    [  499.143779]  [<ffffffff811ea899>] ? fget_light+0x99/0x160
    [  499.149182]  [<ffffffff811ea840>] ? fget_light+0x40/0x160
    [  499.154586]  [<ffffffff8152bc79>] __sys_sendmsg+0x49/0x90
    [  499.159989]  [<ffffffff8152bcd2>] SyS_sendmsg+0x12/0x20
    [  499.165218]  [<ffffffff815fb642>] system_call_fastpath+0x16/0x1b
    [  499.171227] Code: 66 66 66 66 90 55 48 89 e5 41 57 41 89 f7 41
56 41 89 ce 41 55 41 54 4c 8d 67 38 53 48 83 ec 18 89 55 c4 48 8b 57
38 4c 89 45 c8 <4c> 8b 2a 48 8d 42 e8 49
    [  499.171227] IP: 0xffffffff810c584b:
