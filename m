From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Tue, 7 Mar 2017 15:48:25 -0500
Message-ID: <20170307204825.GH31179@htj.duckdns.org>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org>
 <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
 <20170307194134.GE31179@htj.duckdns.org>
 <9ee62e45-6645-454b-11b5-85be746bc81a@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FM7dzyEYiFUpv8MqInriJMoofp/C8eIgHgu0IjSFB1Q=;
        b=Nw+rUEdyiqk5d12DOGBSsncEkb6vEB3fbtVCCAEP7tkbNdkhLn8cleEOE01kjUfzkT
         Xvifj2H1J0GYLJaZrLq4BCMGxOcejsFMbXAbEqvq7FZ0oNFZfgBkaiWlY5d23es0tTBj
         ueqkb0yZV6O9oBgqId3phT7bA76jrCax/8q+7i6EDD1tXP/Rztws6eyFfimPOVoAaVA5
         HDUvs0soQOdaqW8T3WjXcGl9q5MlT4ZUptA4XVaKHoIcYYGVmEJ7xKo45clA6LtmV0kq
         VPteompO3oEpjKaKlQG8/p/63qHnQcgXMcZ7c048yjnYvfzaFZCMGJBgPPEYu1XWzjBT
         GPUg==
Content-Disposition: inline
In-Reply-To: <9ee62e45-6645-454b-11b5-85be746bc81a-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Mar 07, 2017 at 09:06:49PM +0100, Krzysztof Opasiak wrote:
> Personally, I don't want to use rlimit for this as it ends up returning
> error code from for example open() when we hit the limit. This may lead to
> some unpredictable crashes in  services (esp. those poor proprietary binary
> blobs). Instead of injecting errors to service we would like to just get
> notification that this service has more opened fds than it should and ask it
> to restart in a polite way.
> 
> For memory seems to be quite easy to achieve as we can just get eventfd
> notification when application passes given memory usage using memory cgroup
> controller. Maybe you know some efficient method to do the same for fds?

So, if all you wanna do is reliably detecting open(2) failures, can't
you do that with bpf tracing?

Thanks.

-- 
tejun
