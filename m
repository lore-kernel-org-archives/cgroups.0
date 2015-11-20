From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/7] sock, cgroup: add sock->sk_cgroup
Date: Fri, 20 Nov 2015 14:12:28 -0500
Message-ID: <20151120191228.GA28383@mtj.duckdns.org>
References: <1447959171-20749-1-git-send-email-tj@kernel.org>
 <1447959171-20749-7-git-send-email-tj@kernel.org>
 <564EFE25.5000906@bmw-carit.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u3ST4Y/1p7Enl6/pcrrwiMoVuMAODRVwQ2Q35GyJVoQ=;
        b=weYKiG6mj4/FVq1SdpBW1cK4OR+AWM0NnnlDQR2H209HTK8SN1ZmEJ1xzPw0IkPl0k
         TzYAl7qWLYP64pxxoJa6pONpiCquea8aWt4LPZ0Hkddu3734BkDwdgcXIv5JG0VAO6Jr
         U2TSFuXISo5/unDsZmXPLJjnd4XzNpc59/6cXuTDH8Irsestt1Dlw/86SpgQIhQ5mrIM
         6uKJBaWZJPRlxCeYerbLKolmKAnoA+eswTuDh/0IbNCcaa49OA1GmjfJKTBvZr3HoaIM
         dN58wXXDxhxXTdRFfpxFI6fTQjjQZCGHzEPM34VSsXYsrR8b8vlsvEMkq/3MaaVp1x3j
         vtLA==
Content-Disposition: inline
In-Reply-To: <564EFE25.5000906-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org

Hello, Daniel.

On Fri, Nov 20, 2015 at 12:04:05PM +0100, Daniel Wagner wrote:
> >  static inline u16 sock_cgroup_prioidx(struct sock_cgroup_data *skcd)
> >  {
> > -	return skcd->prioidx;
> > +	return (skcd->is_data & 1) ? skcd->prioidx : 1;
> >  }
> >  
> >  static inline u32 sock_cgroup_classid(struct sock_cgroup_data *skcd)
> >  {
> > -	return skcd->classid;
> > +	return (skcd->is_data & 1) ? skcd->classid : 0;
> >  }
> 
> 
> I still try to understand what the code does, hence this stupid question:
> 
> Why is sock_cgroup_prioidx() returning 1 if is not data and
> sock_cgroup_classid() a 0?

I prolly should have added comments there.  prioidx carries the cgroup
ID on the hierarchy net_prio is attached to, so if nothing is
configured, the default value would be the ID of the root cgroup which
is always 1.  For net_cls, the unconfigured default value is zero.
Will refresh the patch with comments.

Thanks.

-- 
tejun
