From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v3 1/8] gpu: rfc: Proposal for a GPU cgroup controller
Date: Mon, 21 Mar 2022 18:37:26 +0100
Message-ID: <20220321173726.GA9640@blackbody.suse.cz>
References: <20220309165222.2843651-1-tjmercier@google.com>
 <20220309165222.2843651-2-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647884249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FG/voD+DgWXmOAGe303ur6CUB56T56c8MHMtIMwufHs=;
        b=ZV6x/1DC0p7tuAxJI2DaKbablWASdPnbFE2nSJ1RXrHZQUwroTi8Q9KwCCRyacn1+ZPueP
        WYBKzbNFNFkbpPdhbqmW+fj0+PZUyLxxW1U2kg7YsSnKmIuBWqSzYB8C8wLxVo90H+4Ss2
        SbJDDHjvSS09x+Abxn2HnFk0v+cBHag=
Content-Disposition: inline
In-Reply-To: <20220309165222.2843651-2-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laur

Hello.

On Wed, Mar 09, 2022 at 04:52:11PM +0000, "T.J. Mercier" <tjmercier-hpIqsD4=
AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> +The new cgroup controller would:
> +
> +* Allow setting per-cgroup limits on the total size of buffers charged t=
o it.

What is the meaning of the total? (I only have very na=EFve
understanding of the device buffers.)

Is it like a) there's global pool of memory that is partitioned among
individual devices or b) each device has its own specific type of memory
and adding across two devices is adding apples and oranges or c) there
can be various devices both of a) and b) type?

(Apologies not replying to previous versions and possibly missing
anything.)

Thanks,
Michal

