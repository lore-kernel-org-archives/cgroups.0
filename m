From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] cgroups: move cgroup_event_listener.c to tools/cgroup
Date: Mon, 7 Jan 2013 09:42:13 -0800
Message-ID: <20130107174213.GL3926@htj.dyndns.org>
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=GaNxRW33SzTbdtw4N/RPt0IDIgqZeoWPHo0BwvOS0m4=;
        b=iho5y0jPuHTDkaHBq1M1puCu2N2+UvdQcb9IguYCNyWOycSDfpZvn541SZCCMkSQ5G
         oE7V/nO/9x6H5gjd0VLsNO1+LigrRBVPqU5ZbunEE5FDvQ94X3fI48IxCZkRMB/ixI3p
         o4cphh2JAQFUqTKbSoAs/bXYqVPBm3Mrb4QDB8yqs9IFgj66a1tQWcjKXF8v+tiLsjGx
         aZb1/HaM4j8ax87NfSWClOS+zbdjo75zfxYx6HZc/t6zzGUVhdRbBh46DuvvQUGf0Bll
         7hUvc7ZYS7WSt2eFJwKBQ9uuk7rJu7Vz9shwyLBBz4SwFdWANYPODiCDM8H5xsXHlLhZ
         jEFg==
Content-Disposition: inline
In-Reply-To: <1357333518-28899-1-git-send-email-gthelen@google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 01:05:17PM -0800, Greg Thelen wrote:
> Move the cgroup_event_listener.c tool from Documentation into the new
> tools/cgroup directory.
> 
> This change involves wiring cgroup_event_listener.c into the tools/
> make system so that is can be built with:
>   $ make tools/cgroup
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
