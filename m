From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 0/5] cgroup: eliminate atomic rstat
Date: Thu, 06 Apr 2023 11:26:02 -0700
Message-ID: <83b2cb8017b945b2b3d3c9e65a3ba94a510ac20f.camel@linux.intel.com>
References: <20230403220337.443510-1-yosryahmed@google.com>
         <CAJD7tkZ5vh5ssDux1LStX9ZivmGmXsFyxfADGJD5AXDaMnGWRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680805563; x=1712341563;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=71j8wA/jyuLPVIohqa23wmw7xUhIc2C3rcA0pSOT7kQ=;
  b=SwLzY0vIgdnUNoYOiwBiqZYCm7dTXGe9Iodg3/63HWpZmAiYk2brQJDv
   X2fYKsEyXsEUlvaU6hIniOeTXqbP5Y9rwdyqJeSNhUtnLU3Z7OJsyFw8D
   jz63OtW0dH8joET+smqIiunQCB3i97Z1UW9+iYXy5lQngL6+4iTY4jsat
   vdAr2yGTDJ1fO8NCaB131xbxzL2io/p3sgEzGOWtxfVXaDgDx7AQ5xiYp
   XdEFB2pwfEBSQgKZ4EnmG6j0Jy6kvuqPhwEjs1wgwUrKb5A86SRrkuQ/j
   gPHcnpFR7xBeVM19OvJTiv/RZy4JkUM8h2BGu3LZyUbLxocUrDgBpi6zJ
   Q==;
In-Reply-To: <CAJD7tkZ5vh5ssDux1LStX9ZivmGmXsFyxfADGJD5AXDaMnGWRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, 2023-04-03 at 15:04 -0700, Yosry Ahmed wrote:
> On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> >=20
> > A previous patch series ([1] currently in mm-unstable) changed most
>=20
> .. and I naturally forgot to link this:
> [1] https://lore.kernel.org/linux-mm/20230330191801.1967435-1-yosryahmed@=
google.com/

Thanks. Saw this after I sent my request for link.

Tim
