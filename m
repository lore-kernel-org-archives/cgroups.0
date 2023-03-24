From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup/cpuset: Find another usable CPU if none found
 in current cpuset
Date: Fri, 24 Mar 2023 19:19:36 +0100
Message-ID: <20230324181936.5sf6xjc5a4vacuku@blackpad>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-4-longman@redhat.com>
 <20230314181749.5b4k6selbgdhl3up@blackpad>
 <58a1a878-fa0b-285d-3e43-2b5103d3c770@redhat.com>
 <20230317122708.ax3m2d4zijkfdzjq@blackpad>
 <ca664da8-0f47-06b2-a94c-82b2f9a1c3aa@redhat.com>
 <20230324143247.GA27199@willie-the-truck>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bnv5nqjb4an3p6ze"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679681978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GsXEmpX7jt/HfXlKrWUvTT6ogyq2n9SaBj4U2OfhPHc=;
        b=CBx76FguKcCbaNh++Rix2ar8jnobmAuieXUZZS19lXDeHSnKBM6hwUD7+5a9uveK9ryyEf
        cEjIxxsPM7+BmtmM34Of1N6aOCJDguL2vO59qwvH6JFhwoXcNxefhwQ3UGdqCSYq5lQvwt
        IPytjsmPLopWx/Ekf7gZ/Rn4Z/z8its=
Content-Disposition: inline
In-Reply-To: <20230324143247.GA27199@willie-the-truck>
List-ID: <cgroups.vger.kernel.org>
To: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


--bnv5nqjb4an3p6ze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 24, 2023 at 02:32:50PM +0000, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> So approaches such as killing tasks or rejecting system calls tend not
> to work as well, since you inevitably get divergent behaviour leading
> to functional breakage rather than e.g. performance anomalies.

What about temporary performance drop from 100% to 0% aka freezing the
tasks for the duration of the mismatching affinity config?


> Having said that, the behaviour we currently have in mainline seems to
> be alright, so please don't go out of your way to accomodate these SoCs.

I see. (Just wondering what you think about the fourth option above.)

Thanks,
Michal

--bnv5nqjb4an3p6ze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZB3ptgAKCRAkDQmsBEOq
uVhEAQC7JaLVG3zxtIHj/KOXOqyJ40tnjVLvv86k89k+Kuk2HAEAuSkfis+4/XkR
nNuhu2FzjdRnT33UwUPZMqfuKUBGeQA=
=Ns6p
-----END PGP SIGNATURE-----

--bnv5nqjb4an3p6ze--
