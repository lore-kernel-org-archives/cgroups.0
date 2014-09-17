From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] cgroup: remove bogus comments
Date: Thu, 18 Sep 2014 06:36:00 +0900
Message-ID: <20140917213600.GC15795@mtj.dyndns.org>
References: <54195FE1.9030607@huawei.com>
 <5419602C.4080303@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6ELoBu6jrXK8dq+GtW+QboZ9hO9Kz56aSlO0DJ96eeg=;
        b=prok176oFLynwk1Tc5VYgdmNcfWSZubyG/JhHtiHqx9eqrDd+1NL+1zQyYJLY+HBVH
         4zMz1Su0eM7oaRFoR0IBje1MdZ9MG0//NGNxNPlAgc7qBKaDItzovOuxTMUvJmB13Wau
         y5ORdAldDwxZTAyGTWzov5ZU8fJPAnsf1KkLJ9wjYawP9UYppC2nOkdys4GqJ/ZEFM2M
         pKswaTf9x7oJlAit57fAJ1GgoIMVV5AjoWKjFTu/XHdtL5ESPXHrqMdQ8uud4UH4i1G5
         BooS0MtfaypZm1CpJp4xn2DeS98lTbU8Tkd+DC7c2e/uGAmAyaV78sW+spUasFo9dAo8
         ljPQ==
Content-Disposition: inline
In-Reply-To: <5419602C.4080303-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Sep 17, 2014 at 06:19:24PM +0800, Li Zefan wrote:
> We never grab cgroup mutex in fork and exit paths no matter whether
> notify_on_release is set or not.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-3 to cgroup/for-3.18.

Thanks.

-- 
tejun
