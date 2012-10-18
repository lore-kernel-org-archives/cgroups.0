From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] hugetlb: do not fail in hugetlb_cgroup_pre_destroy
Date: Thu, 18 Oct 2012 15:48:25 -0700
Message-ID: <20121018224825.GU13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-7-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jQ8MW9YSqKxMODGccc1dpuDLt3Y/qb5VC9jRocG2/fU=;
        b=HzOAy4LbB6DxBvIVPmxUeQ+9uLfiBF0/8CWOPPN2y54uyP20dBAmsp5Ror1Iu1B1mP
         Jx4CCcm0TPaP3qqmGTaLeH7qOZjsh9l/ke5zqRIEAEkEmS/I4ZaaCR9yn5Jw4mtbreFe
         ZfGv5/gbWm+Ynch6AIEmJ9uwCNZLJ6ybAPqFYMaL5JnI2saHR1lKt7eZzS8OV/D6fOcl
         hD4PXbiHLjXlC88zu+bq/38z1FKRHIZCMPzSVKRNtGPlQIsWjEFFy+VjWuBGitDVuqz3
         iOeh7/b+fp/xSnM+KsCG0tRRm9q00h4UpzFDwfBSe8BSxe0XJyBQLJw/xwBE/SjypOFu
         6vvA==
Content-Disposition: inline
In-Reply-To: <1350480648-10905-7-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Oct 17, 2012 at 03:30:48PM +0200, Michal Hocko wrote:
> Now that pre_destroy callbacks are called from within cgroup_lock and
> the cgroup has been checked to be empty without any children then there
> is no other way to fail.
> 
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
