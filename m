From: eballetbo@kernel.org
Subject: Re: [PATCH v7 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Thu, 19 May 2022 11:30:35 +0200
Message-ID: <20220519093034.541481-1-eballetbo@kernel.org>
References: <20220510235653.933868-1-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652952665;
        bh=ymyWwFkIGcEgTX/HoyldR566LvQatVtWXOdUzMjInTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsqjEz6v2uriZ2N0Dq+pndBRjvXvXcsjqqD+SvOkF0pAjllZckSSQYaCIQuEcw1Jy
         2gDuMEW3YDYmQiSxD5oLg6FWYCdEjerCuH613MHsO//W5TSZsctd3moeGrzUDeRe6s
         A9o4YVEYofn+70aKTfqkQvyQKReky8arKQkuzj+/1fx+lWD15H7ZSBUhsWsqXso+2v
         pfcgLj1oqEZBMnIQHSVyd/1eNUlHWeCjPPq+0x8B1shXK+tDzT9UJeTpd9qImfciul
         P2Sn+4aIKue0xebzFbJ0yeibqCMn+utYG9Q8Y8N+qtr7MyADNwqr8dBlCdNZa0fDzj
         bxurpPC3T8esw==
In-Reply-To: <20220510235653.933868-1-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: lizefan.x@bytedance.com, corbet@lwn.net, joel@joelfernandes.org, arve@android.com, tjmercier@google.com, maco@android.com, benjamin.gaignard@collabora.com, tj@kernel.org, brauner@kernel.org, sumit.semwal@linaro.org, tkjos@android.com, surenb@google.com, hannes@cmpxchg.org, Brian.Starkey@arm.com, christian.koenig@amd.com, gregkh@linuxfoundation.org, lmark@codeaurora.org, john.stultz@linaro.org, hridya@google.com, shuah@kernel.org, labbott@redhat.com
Cc: Enric Balletbo i Serra <eballetbo@kernel.org>, cgroups@vger.kernel.org, kernel-team@android.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, cmllamas@google.com, daniel@ffwll.ch, Kenny.Ho@amd.com, linux-kselftest@vger.kernel.org, kaleshsingh@google.com, mkoutny@suse.com, jstultz@google.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org

From: Enric Balletbo i Serra <eballetbo@kernel.org>

On Tue, 10 May 2022 23:56:45 +0000, T.J. Mercier wrote:
> From: Hridya Valsaraju <hridya@google.com>
>

Hi T.J. Mercier,

Many thanks for this effort. It caught my attention because we might have a=
 use
case where this feature can be useful for us. Hence I'd like to jump and be=
 part
of the discussion, I'd really appreciate if you can cc'me for next versions.

While reading the full patchset I was a bit confused about the status of th=
is
proposal. In fact, the rfc in the subject combined with the number of itera=
tions
(already seven) confused me. So I'm wondering if this is a RFC or a 'real'
proposal already that you want to land.

If this is still a RFC I'd remove the 'rfc: Proposal' and use the more cano=
nical
way that is put RFC in the []. I.e [PATCH RFC v7] cgroup: Add a GPU cgroup
controller.

If it is not, I'd just remove the RFC and make the subject in the cgroup
subsystem instead of the gpu. I.E [PATCH v7] cgroup: Add a GPU cgroup

I don't want to nitpick but IMO that helps new people to join to the histor=
y of
the patchset.

> This patch adds a proposal for a new GPU cgroup controller for
> accounting/limiting GPU and GPU-related memory allocations.

As far as I can see the only thing that is adding here is the accounting, s=
o I'd
remove any reference to limiting and just explain what the patch really
introduces, not the future, otherwise is confusing an you expect more than =
the
patch really does.

It is important maintain the commit message sync with what the patch really
does.

> The proposed controller is based on the DRM cgroup controller[1] and
> follows the design of the RDMA cgroup controller.
>=20
> The new cgroup controller would:
> * Allow setting per-device limits on the total size of buffers
>   allocated by device within a cgroup.
> * Expose a per-device/allocator breakdown of the buffers charged to a
>   cgroup.
>=20
> The prototype in the following patches is only for memory accounting
> using the GPU cgroup controller and does not implement limit setting.
>=20
> [1]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty@i=
ntel.com/
>=20

I think this is material for the cover more than the commit message. When I=
 read
this I was expecting all this in this patch.

> Signed-off-by: Hridya Valsaraju <hridya@google.com>
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
> v7 changes
> Remove comment about duplicate name rejection which is not relevant to
> cgroups users per Michal Koutn=C3=BD.
>=20
> v6 changes
> Move documentation into cgroup-v2.rst per Tejun Heo.
>=20
> v5 changes
> Drop the global GPU cgroup "total" (sum of all device totals) portion
> of the design since there is no currently known use for this per
> Tejun Heo.
>=20
> Update for renamed functions/variables.
>=20
> v3 changes
> Remove Upstreaming Plan from gpu-cgroup.rst per John Stultz.
>=20
> Use more common dual author commit message format per John Stultz.
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 69d7a6983f78..2e1d26e327c7 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2352,6 +2352,29 @@ first, and stays charged to that cgroup until that=
 resource is freed. Migrating
>  a process to a different cgroup does not move the charge to the destinat=
ion
>  cgroup where the process has moved.
> =20
> +
> +GPU
> +---
> +
> +The GPU controller accounts for device and system memory allocated by th=
e GPU
> +and related subsystems for graphics use. Resource limits are not current=
ly
> +supported.
> +
> +GPU Interface Files
> +~~~~~~~~~~~~~~~~~~~~
> +
> +  gpu.memory.current
> +	A read-only file containing memory allocations in flat-keyed format. Th=
e key
> +	is a string representing the device name. The value is the size of the =
memory
> +	charged to the device in bytes. The device names are globally unique.::
> +
> +	  $ cat /sys/kernel/fs/cgroup1/gpu.memory.current

I think this is outdated, you are using cgroup v2, right?

> +	  dev1 4194304
> +	  dev2 104857600
> +

When I applied the full series I was expecting see the memory allocated by =
the
gpu devices or users of the gpu in this file but, after some experiments, w=
hat I
saw is the memory allocated via any process that uses the dma-buf heap API =
(not
necessary gpu users). For example, if you create a small program that alloc=
ates
some memory via the dma-buf heap API and then you cat the gpu.memory.current
file, you see that the memory accounted is not related to the gpu.

This is really confusing, looks to me that the patches evolved to account m=
emory
that is not really related to the GPU but allocated vi the dma-buf heap API=
. IMO
the name of the file should be according to what really does to avoid
confusions.

So, is this patchset meant to be GPU specific? If the answer is yes that's =
good
but that's not what I experienced. I'm missing something?

If the answer is that evolved to track dma-buf heap allocations I think all=
 the
patches need some rework to adapt the wording as right now, the gpu wording
seems confusing to me.

> +	The device name string is set by a device driver when it registers with=
 the
> +	GPU cgroup controller to participate in resource accounting.
> +
>  Others
>  ------
>
>
Thanks,
 Enric
=20
