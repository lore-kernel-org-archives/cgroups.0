From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup: Show control files in cgroup2 root after mount
Date: Tue, 18 Jul 2017 16:29:40 -0400
Message-ID: <255cc198-2c10-af76-98ca-086807d11540@redhat.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
 <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
 <20170718201229.GD3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 8ABE27F408
In-Reply-To: <20170718201229.GD3365493@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/18/2017 04:12 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Jul 18, 2017 at 04:00:45PM -0400, Waiman Long wrote:
>> From my own debugging, the controller files (e.g. the debug controller)
>> were indirectly populated by the rebind_subsystems() call.
>>
>> [    1.628103] css_populate_dir: init subsystem debug
> ...
>> [    1.654975]  cgroup_apply_control_enable+0x103/0x340
>> [    1.657719]  cgroup_apply_control+0x1a/0x30
>> [    1.658521]  rebind_subsystems+0x18a/0x3b0
> ...
>
> But there's kernfs_activate() call at the end of rebind_subsystems(),
> so if the files were being added there, it should have been activated
> there and I can confirm that the files are correctly added / removed
> from the cgroup2 root directory when controllers are attached to /
> detached from it.

I think the kernfs_activate() call is for the cgroup1 mount of debug
cgroup which probably failed as I put debug in the cgroup_no_v1= option.
The RHEL7 system that I ran the test on tried to do v1-mount of all the
cgroup controllers available. I am also wondering how a v1-mount of
debug controller will make the controller files appear on cgroup2 root.
Maybe I miss something in the code.

>> For the default cgroup2 root, kernfs_activate() was only called at the
>> beginning in cgroup_init() with only the base cgroup files added. No
>> more call after that until I touched the cgroup.subtree_control file.
> Hmm... we're activating at the end of
>
> * cgroup_setup_root()
> * rebind_subsystems()
> * cgroup_subtree_control_write()
> * cgroup_apply_cftypes() after successful addition
> * cgroup_mkdir()
>
> I *think* this should cover everything.  Just in case, are you looking
> at the mainline kernel?  Can you share how you can reproduce the
> issue?

My test kernel was built out of your latest cgroup git tree with the
thread mode patches on (review-cgroup2-threads-v3 branch).

As I said above, I put in the kernel command line option
"cgroup_no_v1=pids,debug,memory". Then I mounted the cgroup2 filesystem
after boot.

# mount -t cgroup2 cgroup2 /cgroup2
# ls /cgroup2/
cgroup.controllers  cgroup.procs  cgroup.subtree_control  cgroup.threads
# echo +memory > /cgroup2/cgroup.subtree_control
# ls /cgroup2/
cgroup.controllers    debug.current_css_set
cgroup.procs        debug.current_css_set_cg_links
cgroup.subtree_control    debug.current_css_set_refcount
cgroup.threads        debug.masks
debug.csses        debug.taskcount
debug.css_links

Cheers,
Longman



