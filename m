From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Date: Thu, 11 Mar 2021 14:39:36 -0500
Message-ID: <YEpx+HTd/S2EfJCe@slm.duckdns.org>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
 <YEpoS90X19Z2QOro@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=J6ZVBfVZRTkSOXZ58J3mQQUyv5RexzLY8G/YXzNw3gg=;
        b=aeyBPHOo96EVYsMl4EKRqRg7PAOMWcAChCuvfw246ZdPtGEFxCU5KTrsB0CrwxwPV5
         VeofU1Vy+8OGBU14nm3l8e8shZpL2cXu4wVt+1zqc+2zagrT6Ixgo+SXwXqPvIQTyej+
         /5+KcpdjG38fHSNPGd3AXgvkbiZvQtXbTfU9Hr1/1+uK3hWWNzRRuCIcZUFP6+AmfyiG
         fLwqY7StbRxtPyibTYlXFxg4YgN9Wc2tDY6cbjPSafLEp+JD0hFEUpMLMJtXO4lsjqWJ
         EMHXMSN8XdbVX6cALJvJdTxsgIwSBhivrT2abm88VpVpalQuevvoExn7gVv8djmqGWTr
         t3hw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YEpoS90X19Z2QOro@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Mar 11, 2021 at 07:58:19PM +0100, Michal Koutn=FD wrote:
> > Michal, as you've been reviewing the series, can you please take
> > another look and ack them if you don't find anything objectionable?
> Honestly, I'm still sitting on the fence whether this needs a new
> controller and whether the miscontroller (:-p) is a good approach in the
> long term [1].

Yeah, it's a bit of cop-out. My take is that the underlying hardware feature
isn't mature enough to have reasonable abstraction built on top of them.
Given time, maybe future iterations will get there or maybe it's a passing
fad and people will mostly forget about these.

In the meantime, keeping them out of cgroup is one direction, a relatively
high friction one but still viable. Or we can provide something of a halfway
house so that people who have immediate needs can still leverage the
existing infrastructure while controlling the amount of time, energy and
future lock-ins they take. So, that's misc controller.

I'm somewhat ambivalent but we've had multiple of these things popping up in
the past several years and containment seems to be a reasonable approach at
this point.

> [1] Currently, only one thing comes to my mind -- the delegation via
> cgroup.subtree_control. The miscontroller may add possibly further
> resources whose delegation granularity is bunched up under one entry.

Controller enabling and delegation in themselves aren't supposed to have
resource or security implications, so I don't think it's a practical
problem.

Thanks.

--=20
tejun
