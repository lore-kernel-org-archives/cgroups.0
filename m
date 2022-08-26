From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/4] Honor cgroup namespace when resolving cgroup id
Date: Fri, 26 Aug 2022 11:08:04 -1000
Message-ID: <Ywk2NMwurnBYhU+D@slm.duckdns.org>
References: <20220826165238.30915-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=EL3E1bRaXeyNPnn48uCzkwQGEAza0WH8uE9MHfXwpc0=;
        b=i3YwUXBW3Qx0me4zpUqZraIl74Huj1RpfYz7z+IuUhZo8SwtbtnxO3ywnqrwA6VEEO
         feIkxua5CDvMVasxdksGBqUzDRYIiAaYLbtWBa6D75vAF7h0gmZWeySezUDeC55MqIgB
         +V0QRRz0uVhmBgWK6PLMhtEq92jODckRFg69kOtFjBRz+s9YXljL56Q0RR9txGsoH8dN
         Vm3ykAM4wFf+18yQuQC/iMGtcBtggjF7J3u/1UzVCGV54m58fi6wBclz6j2EQvFRJXJy
         Lb9Mf154iT9BkCEsBWDJVC1DITZuDu6tNCp8A/yYJ16XO/Ht8U4lG2gfcCKY2ZrlluQN
         mUog==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220826165238.30915-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, Aditya Kali <adityakali@google.com>, Serge Hallyn <serge.hallyn@canonical.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yonghong Song <yhs@fb.com>, Muneendra Kumar <muneendra.kumar@broadcom.com>, Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>

Hello,

On Fri, Aug 26, 2022 at 06:52:34PM +0200, Michal Koutn=FD wrote:
> Cgroup id is becoming a new way for userspace how to refer to cgroups it
> wants to act upon. As opposed to cgroupfs (paths, opened FDs), the
> current approach does not reflect limited view by (non-init) cgroup
> namespaces.

Looking at the code, I'm not quite sure we're actually plugging all holes in
terms of lookup. I think cgroup_get_from_path() would allow walking up past
the ns boundary. We aren't using kernfs ns support and I don't see anything
preventing ..'ing past the boundary.

> This patches don't aim to limit what a user can do (consider an uid=3D0 in
> mere cgroup namespace) but to provide consistent view within a
> namespace.

Considering userns and the fact that we try to isolate two separate sub
hierarchies delegated to the same UID, I think we'd have to tighten down on
the behaviors so that visiblity scope matches the permission scope.

Thanks.

--=20
tejun
