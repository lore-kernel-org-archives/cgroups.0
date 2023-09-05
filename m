From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes
 help unified flushes
Date: Tue, 5 Sep 2023 18:07:04 +0200
Message-ID: <r5rbfskjjhkp5pjlwi7xqluc5lxq7bxo44gmxwhihn62ea75wp@iljnpiqo5dcr>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-4-yosryahmed@google.com>
 <ZPXupwjewuLgksAI@dhcp22.suse.cz>
 <6tne52ip62ucev7nmnim3m7fhcydnwcytyxynrlxxgaf4cbqea@r4hec425izap>
 <ZPX6luPGqypp68+L@dhcp22.suse.cz>
 <hrpw2bjsrs3pzxympb7cz4nohyeztnxkmdtzbzlfdba6ugkken@dhcdbbbrv4fn>
 <CAJD7tkaHVtMiMYFocNiABuyhPcqt77gei0UeaDq4J7V-=tMFYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6stuxi5kzfaubddj"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693930025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z7DpwVTdzkO9zvTaC0Nmsn1euztwCXxmkNCfH0qy/6k=;
        b=JuwiWsstsUx/RiXnQTVhHoohB5z8AqUuTYPwJqVfD3uJUgTGfqPeVba5V5NEEDW0ewNbK9
        2wvuBRryGXfUBvhrEM36nhox84C+PqP2ReSDma8+WWvRf7DZGDThb4CHbjJ0OSiyUZiTSv
        eZEMTFKIhS+9vnd097bZdCl7RTDQRUE=
Content-Disposition: inline
In-Reply-To: <CAJD7tkaHVtMiMYFocNiABuyhPcqt77gei0UeaDq4J7V-=tMFYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--6stuxi5kzfaubddj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 05, 2023 at 08:54:46AM -0700, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> How would that create a userspace visible behavior that a dependency
> can be formed on?

A userspace process reading out root memory.stat more frequently than
in-kernel periodic flusher.

> Users expecting reclaim to be faster right after reading root stats?

Yes, that is what I had in mind.

> I would guess that would be too flaky to cause a behavior that people
> can depend on tbh.

I agree it's a weird dependency. As I wrote, nothing that would be hard
to take away.


Michal

--6stuxi5kzfaubddj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZPdSJgAKCRAGvrMr/1gc
jvq0AP4lfNlWmGAFoLBq4DgbaLXZ/uCv05XZGxsrYdHcWo+uwAD8DGnuohLoPyYb
uBX+a5AsCXJZEgbqY1PGUk/edfszRAk=
=PUkx
-----END PGP SIGNATURE-----

--6stuxi5kzfaubddj--
