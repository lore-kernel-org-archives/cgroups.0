From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 20:42:05 +0200
Message-ID: <2023062845-stabilize-boogieman-1925@gregkh>
References: <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
 <ZJuSzlHfbLj3OjvM@slm.duckdns.org>
 <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner>
 <CAJuCfpHqZ=5a_2k==FsdBbwDCF7+s7Ji3aZ37LBqUgyXLMz7gA@mail.gmail.com>
 <20230628-faden-qualvoll-6c33b570f54c@brauner>
 <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
 <20230628-spotten-anzweifeln-e494d16de48a@brauner>
 <ZJx1nkqbQRVCaKgF@slm.duckdns.org>
 <CAJuCfpEFo6WowJ_4XPXH+=D4acFvFqEa4Fuc=+qF8=Jkhn=3pA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687977728;
        bh=s+CFIQ47Nde7laYIREkJnwD6OP0zOQzRI431me7l5hM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r96QzmwlwrrCKx+UBddlEPORTg571sdls578CN138pCbKjYbvVHbeEwBB+YEI/Pi3
         WWYvoqWWWCuimtfQ3WjeWhwNlwhF0KtCIqtOaP+XN9kppPSgPqyU8jfWo84XdQyr5Y
         PqlZT3ZXZgVIDHeStH6VizDAk1Xy0Qovl+03GMwI=
Content-Disposition: inline
In-Reply-To: <CAJuCfpEFo6WowJ_4XPXH+=D4acFvFqEa4Fuc=+qF8=Jkhn=3pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Wed, Jun 28, 2023 at 11:18:20AM -0700, Suren Baghdasaryan wrote:
> On Wed, Jun 28, 2023 at 11:02=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yRO=
fE0A@public.gmane.org> wrote:
> >
> > On Wed, Jun 28, 2023 at 07:35:20PM +0200, Christian Brauner wrote:
> > > > To summarize my understanding of your proposal, you suggest adding =
new
> > > > kernfs_ops for the case you marked (1) and change ->release() to do
> > > > only (2). Please correct me if I misunderstood. Greg, Tejun, WDYT?
> > >
> > > Yes. I can't claim to know all the intricate implementation details of
> > > kernfs ofc but this seems sane to me.
> >
> > This is going to be massively confusing for vast majority of kernfs use=
rs.
> > The contract kernfs provides is that you can tell kernfs that you want =
out
> > and then you can do so synchronously in a finite amount of time (you st=
ill
> > have to wait for in-flight operations to finish but that's under your
> > control). Adding an operation which outlives that contract as something
> > usual to use is guaranteed to lead to obscure future crnashes. For a
> > temporary fix, it's fine as long as it's marked clearly but please don't
> > make it something seemingly widely useable.
> >
> > We have a long history of modules causing crashes because of this. The
> > severing semantics is not there just for fun.
>=20
> I'm sure there are reasons things are working as they do today. Sounds
> like we can't change the ->release() logic from what it is today...
> Then the question is how do we fix this case needing to release a
> resource which can be released only when there are no users of the
> file? My original suggestion was to add a kernfs_ops operation which
> would indicate there are no more users but that seems to be confusing.
> Are there better ways to fix this issue?

Just make sure that you really only remove the file when all users are
done with it?  Do you have control of that from the driver side?

But, why is this kernfs file so "special" that it must have this special
construct?  Why not do what all other files that handle polling do and
just remove and get out of there when done?

thanks,

greg k-h
