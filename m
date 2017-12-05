From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] writeback: sync returns with dirty pages exist
Date: Tue, 5 Dec 2017 10:20:07 -0800
Message-ID: <20171205182007.GV2421075@devbig577.frc2.facebook.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ldWK5kAoxjG7IYVY/vfW8e4GAbRq7EuSLQp/8lcqIuk=;
        b=F2xy7V3C/N0YCLQHCn4FWA+NpI3ox8R4us4ZnIsCUAq9WPFx97120Rfh2zreA0he04
         7Xh8Cv2XfJQmeeLvBIeM7uEt0QdsDaVQJ5GTrIiV6EJ+PFWPdw/AjP8pzJEJjfLDQcpP
         ojZWLkzYULNkve8yS0Q1NVR1DqSx4idOwlQZo9lsxWwkpehKYflevEncMKnI2VJXvDrj
         x5wr5LtkSNvkLQ/G/97m+0ZdhRrq40rj0Ek8DH2CXo0gSwo6MLzHEa13Hi+qNsObl8Rk
         o/ePFJdRKiR4KeqkpWehOGIqpSc50ud1iuri9b9d1XBBvw8wgHJW8Ptxx4H8bWyqUhIJ
         9Jdg==
Content-Disposition: inline
In-Reply-To: <dc694ae2-f07f-61e1-7097-7c8411cee12d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Xuejiufei.

On Mon, Dec 04, 2017 at 03:13:34PM +0800, xuejiufei wrote:
> I have found that system call sync may return even if dirty pages still
> exist. This is caused by the following case:
>
> sync
> -> sync_inodes_sb()
>   -> bdi_split_work_to_wbs() queue works for each wb
>   -> wb_wait_for_completions() wait for these works to complete.
> 
> >>>>>> race window. Writeback thread found it should switch to another
> new wb while doing foreign cgroup detect. So a new wb is created, and
> the inodes are move from old wb to the new one. The writeback work for
> old wb is done, so the sync process is woken while the inodes with dirty
> pages are still queued in new wb.

So, wb_wait_for_completion() may end up returning earlier than
expected but data integrity is waited by wait_sb_inodes() which isn't
affected by inode cgroup wb migrations.  Have you actually seen this
happening?

Thanks.

-- 
tejun
