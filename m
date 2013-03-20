From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to threadgroup_lock
Date: Wed, 20 Mar 2013 11:42:25 -0700
Message-ID: <CAOS58YPxGXt+iq1GZ4hryqm1Z_p+r7eRRC7ruUDDd=LQrWtAxg@mail.gmail.com>
References: <20130307180139.GD29601@htj.dyndns.org>
	<20130307180332.GE29601@htj.dyndns.org>
	<20130307191242.GA18265@redhat.com>
	<20130307193820.GB3209@htj.dyndns.org>
	<513A9A67.60909@huawei.com>
	<20130309032936.GT14556@mtj.dyndns.org>
	<513AE918.7020704@huawei.com>
	<20130319220246.GR3042@htj.dyndns.org>
	<514909A0.4030808@huawei.com>
	<20130320150351.GW3042@htj.dyndns.org>
	<20130320183523.GA29365@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=2eAnXWM+fv4grGcVlS+uwyZuUflTn++sw9chrFtXMY0=;
        b=qRdQL/sVIWYuW7tb5uInL09QoJskxe32VDt378RR6//Nqz4VuO38fSz0BKhyUn4UXw
         sQ3XiGDDph7mpDfcwHO2B4D9367jTLgObkKMpJustc+PvFvb59wtYol0JdQf8N2jclwh
         eV/SCT5sxQnU/ci5Ilnmz2xi+mhezvlfcfvWGW/FGOZcbbFczS+bVpoExgODU7tVmiGC
         JGHdmBGThFeaOzrVVwOaspxmz3TnWLu0ZN+pmdByxU3BMP6gQrVwGFTqExyYLLn0kvR4
         YDOZuQqxJrMuNlBNyC8bI02lKnPcTJiD1UqW8CtB70WB95xDEg88LAqclb3uYW0HmagB
         91uA==
In-Reply-To: <20130320183523.GA29365-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 20, 2013 at 11:35 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> then we need "do not abuse ->cred_guard_mutex in threadgroup_lock()"
> acked by you and Li. Please let me know if I should resend it.

Yeah, we want that one regardless of this one. Please feel free to add
my Acked-by (if I hadn't acked already, that is). How should your
patch be routed? Through -mm?

Thanks.

-- 
tejun
