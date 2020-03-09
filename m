From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Mon, 9 Mar 2020 15:51:20 -0400
Message-ID: <20200309195104.GA77841@mtj.thefacebook.com>
References: <C16IH7NEXW4J.440OGTNY7CWX@dlxu-fedora-R90QNFJV>
 <6bbfc8b8c9c206d80de43a64bfe4b8083cc2c02f.camel@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c1osNqRAKc0726dqEwHuKyvC5yuBvSfA/WeWwR//zkA=;
        b=rHHHsldRAuzPzsRgPpYEEF41npGcL20HK/bsJw2992ey9MCD1z2d/FuTLQuxE7Z7+U
         UjjRUAWlDcX/hB45O4nq7ukPOkA6tW26Rm5nFJWVe0NEtEWkRX3zjZ/MHACLc22D2njO
         gg7yxHAarOUO5a8tZGMxrF0Und3s1CJWP3XrMOgP8aqlhpsA2V00Sfovg2MMnzIz/q/Y
         z95z15IJyPmsgsifkmYCj+k22WS8M1Rk6mvHcTfr2znjU3uThKNQ0rJpr5w21p6mdZTV
         X0CVA6FjslyawUt5y/SULEsAXCb5NzFPr8XH50Ej7T3a/gbf8EqzGvn3NFjM85Xn/odz
         qGaA==
Content-Disposition: inline
In-Reply-To: <6bbfc8b8c9c206d80de43a64bfe4b8083cc2c02f.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Mar 09, 2020 at 12:41:05PM -0700, Joe Perches wrote:
> If the need is to allocate from a single block of memory,
> perhaps you need a submemory allocator like gen_pool.
> (gennalloc.h)
> 
> Dunno.  Maybe i just don't quite understand your need.

vmalloc is the right thing to do here. vmalloc space isn't a scarce
resource on any 64bit machines. On 32bits, which basically are tiny
machines at this point, these allocations are both size and quantity
limited by other factors (e.g. each cgroup consumes way more memory).

-- 
tejun
