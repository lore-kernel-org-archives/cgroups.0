From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCHSET cgroup/for-4.3] cgroup,memcg: generalize event
 handling and enable notifications on "memory.events"
Date: Mon, 17 Aug 2015 23:29:20 +0200
Message-ID: <20150817212920.GA29138@cmpxchg.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 11, 2015 at 01:58:01PM -0400, Tejun Heo wrote:
> Hello,
> 
> This patchset establishes conventions on low frequency events,
> converts "cgroup.populated" to "cgroup.events" accordingly,
> generalizes event handling and enable notifications for
> "memory.events".
> 
> This patchset contains the following eight patches.
> 
>  0001-cgroup-replace-cgroup.populated-with-cgroup.events.patch
>  0002-cgroup-replace-cftype-mode-with-CFTYPE_WORLD_WRITABL.patch
>  0003-cgroup-relocate-cgroup_populate_dir.patch
>  0004-cgroup-make-cgroup_addrm_files-clean-up-after-itself.patch
>  0005-cgroup-cosmetic-updates-to-rebind_subsystems.patch
>  0006-cgroup-restructure-file-creation-removal-handling.patch
>  0007-cgroup-generalize-obtaining-the-handles-of-and-notif.patch
>  0008-memcg-generate-file-modified-notifications-on-memory.patch
> 
> 0001 replaces "cgroup.populated" with "cgroup.events".  0002-0006 are
> prep patches.  0007 generalizes event notification.  0008 hook up
> event notifications for "memory.events".

These look good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Out of curiosity, do you envision additional entries for cgroup.events
in the near future?
