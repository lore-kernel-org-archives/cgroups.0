From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Mon, 01 May 2023 22:22:18 -0400
Message-ID: <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel__45178.5050494195$1682994178$gmane$org@HansenPartnership.com>
References: <20230501165450.15352-1-surenb@google.com>
         <20230501165450.15352-2-surenb@google.com>
         <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
         <ZFAUj+Q+hP7cWs4w@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1682994147;
        bh=XleaLi6oRjXtfe2D7RhL/bXb9kAyYfGf1xyiXtDlQDk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=B3+pvvNt1nRN8hRoSXjf3I4ybVi/EDboNnvLeMqv3k3o/5KuewFLsQ2LIIO45T87D
         dmw9Bza7VZEKEtygO+CQeSy7CBK508rzVVZKe8uhSLnG5n4AwGQmHHjTyQBjyKut87
         W4mECobpPwTueeG1X8Y0LfbxM9hzHFolb5i0L6ew=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1682994146;
        bh=XleaLi6oRjXtfe2D7RhL/bXb9kAyYfGf1xyiXtDlQDk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=m6bYz5hNQXdxoZ5NOAcJ2JFL0kL9SDAdXRGd+EFNCj+3OnfQ3+swh//Kmg4+1ZxnT
         /vAaVHfPpqrg0q8i1pJguyqq2gnSLJOdqlrDbhqXY73Dx/2yBSTryYz6FylsmhHOQk
         kWyP5cXIJTuLLvuvIQl6DHYlZBed/Vghiiim+rwE=
In-Reply-To: <ZFAUj+Q+hP7cWs4w-jC9Py7bek1znysI04z7BkA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells@redhat.c

On Mon, 2023-05-01 at 15:35 -0400, Kent Overstreet wrote:
> On Mon, May 01, 2023 at 11:13:15AM -0700, Davidlohr Bueso wrote:
> > On Mon, 01 May 2023, Suren Baghdasaryan wrote:
> > 
> > > From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > > 
> > > Previously, string_get_size() outputted a space between the
> > > number and the units, i.e.
> > >  9.88 MiB
> > > 
> > > This changes it to
> > >  9.88MiB
> > > 
> > > which allows it to be parsed correctly by the 'sort -h' command.
> > 
> > Wouldn't this break users that already parse it the current way?
> 
> It's not impossible - but it's not used in very many places and we
> wouldn't be printing in human-readable units if it was meant to be
> parsed - it's mainly used for debug output currently.

It is not used just for debug.  It's used all over the kernel for
printing out device sizes.  The output mostly goes to the kernel print
buffer, so it's anyone's guess as to what, if any, tools are parsing
it, but the concern about breaking log parsers seems to be a valid one.

> If someone raises a specific objection we'll do something different,
> otherwise I think standardizing on what userspace tooling already
> parses is a good idea.

If you want to omit the space, why not simply add your own variant?  A
string_get_size_nospace() which would use most of the body of this one
as a helper function but give its own snprintf format string at the
end.  It's only a couple of lines longer as a patch and has the bonus
that it definitely wouldn't break anything by altering an existing
output.

James

