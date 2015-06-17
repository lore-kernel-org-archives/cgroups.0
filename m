From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] cgroup, writeback: misc
 updates for cgroup writeback support
Date: Wed, 17 Jun 2015 14:31:03 -0400
Message-ID: <20150617183103.GK22637@mtj.duckdns.org>
References: <1434494912-31043-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=s0RjFwOKZlM/Wrtbsr6RI9PExXXdfsKTfV5QsGb17E8=;
        b=kFnYu+Su8Ue6cJiPbgIrYbGq8fdcSJbEW3idjCSF6EYxrVy5H19RmEuz5JiLUT6w5D
         AD1c/zSa/4idtcBUvpS0ndkWqG/NGo2B1DoPv7gT98TW0TSOoMgN88rChOJ/KhIwQI5y
         SxGrqNe2/bLrkrdzlWhz5hncAsFeRvSNXkT9EvxlpOrZXhURkUAkH1MbM8opfS5hj2bU
         i1iOgx32HYJZpWms9og8mHPPwLW9sYbKQ0Y2LlD8lgxvUgumJ6CCnOhp2ItryUI7meNP
         PJTuJcgmcVzfTpNbzZRwXvkuH6BiGwwQqRfHTfCFfY+WpCVlyzsCIdF0S+V2PNP9BMXZ
         CclA==
Content-Disposition: inline
In-Reply-To: <1434494912-31043-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jun 16, 2015 at 06:48:29PM -0400, Tejun Heo wrote:
> Hello,
> 
> This is v2.  The only change from the last take[L] is
> 
> * super_block->s_iflags added and MS_CGROUPWB replaced with
>   SB_I_CGROUPWB as suggested by Christoph and Jan.
> 
> This patchset contains the following assorted updates for the cgroup
> writeback support.
> 
>  0001-writeback-do-foreign-inode-detection-iff-cgroup-writ.patch
>  0002-vfs-writeback-replace-FS_CGROUP_WRITEBACK-with-SB_I_.patch
>  0003-writeback-blkio-add-documentation-for-cgroup-writeba.patch
> 
> 0001 fixes a bug where clear FS_CGROUP_WRITEBACK flag didn't fully
> disable cgroup writeback support if the filesystem code uses
> wbc_init_bio() and wbc_account_io().
> 
> 0002 replaces FS_CGROUP_WRITEBACK with SB_I_CGROUPWB so that cgroup
> writeback support can be enabled / disabled per superblock rather than
> filesystem type.
> 
> 0003 updates blkio documentation with information on cgroup writeback
> support.

Jens, this is late in the merge window but these three patches are low
risk and would be nice to make available for -rc1 so that future
filesystem cgroup writeback support doesn't have to pull in cgroup
branch.  What do you think?

Thanks.

-- 
tejun
