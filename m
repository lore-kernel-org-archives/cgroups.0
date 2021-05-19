From: Glaive Neo <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fw: User-controllable memcg-unaccounted objects of time namespace
Date: Wed, 19 May 2021 19:43:56 +0800
Message-ID: <CAELef9p42mQ5fvde3A7RSRZDNoDPP+VkR_3TJ5OPQYWsSQk07g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=KvQEt0Pbe3v9Z/6IbeJxPBUgmCm+xqGUBv92hphBoAs=;
        b=KMYlpNlJawOoZQ0mx8WQC9BeQdHxhNu+IsxGWLcMeAAlzLp0G7i1RZsY/s8sQbPxKk
         bSHbS/D3idx1OTwd0CIRoMdlcdlN4YXf9iGsHONkkiyI+5DSRmsFiakMAcatzFdzUyKp
         Qnw1xV/dWCGKs2o9a5r3nrtTGa7CV8ex/+Tu81qsRNk1miaRPS59GGeJT1eWv7b24ghE
         XCcW19WfGNAjCYP6RUi5Vjxi60DYJUUECjTA+lqZjaZ2boRDQM3mqiY1pyyYxiuw4Odg
         GzJ5etm2QP/gISftGDQQSQjohyfq2pI1MBvRv9jWNnv/rvB/aCIApyUKKCkXfFX3dfyr
         uKtg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org" <shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

CC reply. Sorry for occupying your time. I was unaware that I had to
use plain text e-mail to make public mailing list accept it, and I
omitted these addresses to avoid rejecting notification.

Yutian Yang,
Zhejiang University


> -----Original Messages-----
> From: "Michal Hocko" <mhocko-IBi9RG/b67k@public.gmane.org>
> Sent Time: 2021-05-19 17:18:45 (Wednesday)
> To: "Yutian Yang" <ytyang-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
> Cc:
> Subject: Re: Fw: Re: Re: User-controllable memcg-unaccounted objects of t=
ime namespace
>
> Did you plan to post this reply to the mailing list with the whole
> original CC list?
>
> On Wed 19-05-21 16:56:27, Yutian Yang wrote:
> >
> >
> >
> > -----Original Messages-----
> > From: "Yutian Yang" <ytyang-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
> > Sent Time: 2021-05-18 19:29:40 (Tuesday)
> > To: "Michal Hocko" <mhocko-IBi9RG/b67k@public.gmane.org>
> > Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8@public.gmane.org=
m>, "shenwenbosmile-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shenwenbosmile-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Subject: Re: Re: User-controllable memcg-unaccounted objects of time na=
mespace
> >
> > Sorry for the delayed response. I believe our patches are necessary and=
 will answer your questions piece by piece.
> >
> > For the practicality of our concerns, we have confirmed that repeatedly=
 creating new namespaces could lead to breaking memcg limit. Although the n=
umber of namespaces could be limited by per-user quota (e.g., max_time_name=
spaces), depending on per-user quota to limit memory usage is unsafe and im=
practical as users may have their own considerations when setting these lim=
its. In fact, limitation on memory usage is more foundamental than limitati=
on on various kernel objects. I believe this is also the reason why the fd =
tables and pipe buffers have been accounted by memcg even if they are also =
under per-user quota's limitation. The same reason applies to limitation of=
 pid cgroups. Moreover, both net and uts namespaces are properly accounted =
while the others are not, which shows inconsistencies.
> >
> > For other unaccounted allocations (proc_alloc_inum, vvar_page and likel=
y others), we have not reached them yet as our detecting tool reported many=
 results which require much manual effort to go through. To me, it seems th=
at these allocations also need patches.
> >
> > Lastly, our work is based on a detecting tool and we only report missin=
g-charging sites that are manually confirmed to be triggerable from syscall=
s. The results that are obviously unexploitable like uncharged ldt_struct, =
which is allocated per process, are also filtered out. We would like to con=
tinuously contribute to memcg and we are planning to submit more patches in=
 the future.
> >
> > Thanks!
> >
> > Yutian Yang,
> > Zhejiang University
> >
> >
> > > -----Original Messages-----
> > > From: "Michal Hocko" <mhocko-IBi9RG/b67k@public.gmane.org>
> > > Sent Time: 2021-04-16 14:29:52 (Friday)
> > > To: "Yutian Yang" <ytyang-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
> > > Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, "shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org" <shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>=
, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Subject: Re: User-controllable memcg-unaccounted objects of time name=
space
> > >
> > > Thank you for this and other reports which are trying to track memcg
> > > unaccounted objects. I have few remarks/questions.
> > >
> > >
> > > On Thu 15-04-21 21:29:57, Yutian Yang wrote:
> > > > Hi, our team has found bugs in time namespace module on Linux kerne=
l v5.10.19, which leads to user-controllable memcg-unaccounted objects.
> > > > They are caused by the code snippets listed below:
> > > >
> > > > /*--------------- kernel/time/namespace.c --------------------*/
> > > > ......
> > > > 91ns =3D kmalloc(sizeof(*ns), GFP_KERNEL);
> > > > 92if (!ns)
> > > > 93goto fail_dec;
> > > > ......
> > > > /*----------------------------- end -------------------------------=
*/
> > > >
> > > >
> > > > The code at line 91 could be triggered by syscall clone if
> > > > CLONE_NEWTIME flag is set in the parameter. A user could repeatedly
> > > > make the clone syscall and trigger the bugs to occupy more and
> > > > more unaccounted memory. In fact, time namespaces objects could be
> > > > allocated by users and are also controllable by users. As a result,
> > > > they need to be accounted and we suggest the following patch:
> > >
> > > Is this a practical concern? I am not really deeply familiar with
> > > namespaces but isn't there any cap on how many of them can be created=
 by
> > > user? If not, isn't that contained by the pid cgroup controller? If e=
ven
> > > that is not the case, care to explain why?
> > >
> > > You are referring to struct time_namespace above (that is 88B) but I =
can
> > > see there are other unaccounted allocations (proc_alloc_inum, vvar_pa=
ge
> > > and likely others) so why the above is more important than those?
> > >
> > > Btw. a similar feedback applies to other reports similar to this one.=
 I
> > > assume you have some sort of tool to explore those potential run away=
s
> > > and that is really great but it would be really helpful and highly
> > > appreciated to analyze those reports and try to provide some sort of
> > > risk assessment.
> > >
> > > Thanks!
> > > --
> > > Michal Hocko
> > > SUSE Labs
>
> --
> Michal Hocko
> SUSE Labs
