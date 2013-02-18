From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] Revert "cgroup: fix cgroup_path() vs rename() race"
Date: Mon, 18 Feb 2013 09:07:56 -0800
Message-ID: <20130218170756.GC17414@htj.dyndns.org>
References: <51205684.5040407@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=HccifpfDgWHnlwijSU0HzBPvoAGfkwHiZpTnGzSS4yo=;
        b=FSUXTd8cWLykyYpjfKc4FqfQILXC6WYO+1VkVpgc+gqsSjnslpmKzZ66y42ZTAWrc9
         4TZeYcErcsIhoNwtOuKmoo++C1fN+ihn6gxSTrSMZ74gfVHLQvk/ptKol/JgJSSvcmu7
         Q8QPqNOPQrgxafa7JZZQtEAzSI6pDt+TwGceezTpjkL4KSmwM/rEU2J+rM1DRQchdlqy
         m9xw/pEiQKwt36lUsZ/66Ds4PvSa+goylVYW723vRTQGPPLSrSbwAvMJHnoQu6TkcITz
         6O7mOEW2IEEW3Uskme1P4uNKsSvELtB7aMPCwrtQWPOxWt/dBQwwZZ6y5l7pZI2C9PIU
         C9ew==
Content-Disposition: inline
In-Reply-To: <51205684.5040407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

Hello, Li.

On Sun, Feb 17, 2013 at 12:03:16PM +0800, Li Zefan wrote:
> This reverts commit 299772fab304ab3a36b22b5d28ed81f9408972e7

I didn't push 299772 to 3.8.  I forgot about it for a couple weeks and
then it felt too late and was planning to push it through for-3.9.
I'm just gonna drop for-3.8-fixes and cherr-pick the following two
commits into for-3.9.

 * 7ccff5e0e9 ("cgroup: fix exit() vs rmdir() race")
 * 0844ab1e68 ("cpuset: fix cpuset_print_task_mems_allowed() vs rename() race")

Thanks.

-- 
tejun
