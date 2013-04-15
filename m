From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
Date: Sun, 14 Apr 2013 20:57:20 -0700
Message-ID: <20130415035720.GN3050@htj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
 <1365964619-14762-5-git-send-email-tj@kernel.org>
 <516B7753.9060503@huawei.com>
 <20130415034613.GK3050@htj.dyndns.org>
 <516B78E5.6000109@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=P6cYFte2CXsHBmi878xkZJooAGOiFRXYztqy+GqmD7s=;
        b=UNHuBll6rN6GwmrlewUdiAJc3L0KkPqA+EUmjOU7fpqtGwdhinPxfzNXAJZDfAbpue
         MnWimokbqqjeu06ns8kVVILoDIKvi753AQVfjwIE2brrG4F5gyXP/5uFiMP9dZJHJq6K
         xYNOgRQv2mBi8UzyGVKYdCZvsFBahWEA/S2d0ZEaxmmjs8HhF6656KFjMLxkoRot9q2l
         46lBdORXeT7pyQa+HkxW1MmUBv9tQtSnU+fWW5EKzduE/Kw2VcO76dAGCHabAX1k0jJ9
         C6UACIsjeYs7GgV5V6nfDqd4HhZ3eENjkITSG45NYVxC1ZeSBT1c08YUMyG9RiN/ZZyT
         SSpw==
Content-Disposition: inline
In-Reply-To: <516B78E5.6000109-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org

Hey, Li.

On Mon, Apr 15, 2013 at 11:49:57AM +0800, Li Zefan wrote:
> But if id is invalid, idr_find() will return NULL. As long as root is not NULL,
> task_cgroup_from_root() will always return a valid cgroup.

I'm hopping across multiple devel branches quickly today and somewhat
tipsy.  Sorry about the blabber.  :)

-- 
tejun
