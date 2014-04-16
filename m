From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kernfs: move the last knowledge of sysfs out from kernfs
Date: Wed, 16 Apr 2014 12:46:07 -0400
Message-ID: <20140416164607.GJ1257@htj.dyndns.org>
References: <1397666401-10427-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1I8BKPURfIhyvdTlGvAnEt8A0deYD1cMLLDDUK9LwOI=;
        b=P4yE0vokyDrg1bxWAI3xk/q5d/qn35iQ3ehG70KcYwEXwvOb+sK6zS5TIrNTJ0tI1Y
         rI+mlKWyEQZKFW/+EQNWRHIxHLOUbCgI3Lqa3Dwfzlb7no2YDSTVGfQqUWqimGg4o+pK
         oZOYR7zF+D3hIYRCXwdvDQuclHaEqBfmwVFxmp16bSvMa39ME6Fr9ZUm15A/EEbp/OYZ
         xT98wIOqxSElLIfPzREWqgDWyF5hi5PHdnKbhrelAPw+aAz31UP/nSY5FZxB9BqM033h
         Fcd2Zx4D9RtUnipV7odKRPT0tlm5937pxQzF8HpelU0qIQd2u4vffxXfZmSBudJaQkcQ
         QsEw==
Content-Disposition: inline
In-Reply-To: <1397666401-10427-1-git-send-email-nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Apr 17, 2014 at 12:40:01AM +0800, Jianyu Zhan wrote:
> @@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * @flags: mount flags specified for the mount
>   * @root: kernfs_root of the hierarchy being mounted
>   * @new_sb_created: tell the caller if we allocated a new superblock
> + * @private: any file system specifc private data

Please put it before @new_sb_created.  Also, why isn't it unsigned
long magic?

Thanks.

-- 
tejun
