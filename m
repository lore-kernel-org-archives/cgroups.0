From: Martijn Coenen <maco@google.com>
Subject: Re: [PATCH] memcg: Only free spare array when readers are done
Date: Thu, 14 Jan 2016 16:23:00 +0100
Message-ID: <CA+_MTtwSjEwfpE3+jxywJKTzui5d_J1PbK5E3V74rQOXo0317w@mail.gmail.com>
References: <001a113abaa499606605294b5b17@google.com>
	<20160114143847.GD5046@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=94eb2c031094b6b66305294cdc07
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=V9eHehPNXkzQ46J3ft6CR85EcvD6tOlhJYUu65Ab+FY=;
        b=bDBeocQcnpQaUNUaepXcOOwK2iCVqOAe82e0EcoUjQElpyehGQ+XPGjL8V39O2QiMH
         QGgeWggffabA/OQCmnUZGz0LLUEYQnolaYtQrZiwiBQKUnCzBEsYc4Pu5py5AtexVxhU
         ZlW4NGBygrFk7+UArdeTJH02r8q8j98EvR+f3lrBQU7ysdwRn4q0OIsK8PWXmwORC+RO
         MhzZk4HoyONQiyUCGzMunAAyWqlgTbA8PaoeCQrm27OLT9e2lc1LIt/RGZU0Oj8XVf7s
         FxJnvWLUNxRYKSMnMrwANOa4z1rB2gMDOW2uMHptv2IEy8n+ltzcCgCpzfYS1bBIMXd+
         zhrQ==
In-Reply-To: <20160114143847.GD5046@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

--94eb2c031094b6b66305294cdc07
Content-Type: text/plain; charset=UTF-8

On Thu, Jan 14, 2016 at 3:38 PM, Michal Hocko <mhocko@kernel.org> wrote:

> On Thu 14-01-16 14:33:52, Martijn Coenen wrote:
> > A spare array holding mem cgroup threshold events is kept around
> > to make sure we can always safely deregister an event and have an
> > array to store the new set of events in.
> >
> > In the scenario where we're going from 1 to 0 registered events, the
> > pointer to the primary array containing 1 event is copied to the spare
> > slot, and then the spare slot is freed because no events are left.
> > However, it is freed before calling synchronize_rcu(), which means
> > readers may still be accessing threshold->primary after it is freed.
>
> Have you seen this triggering in the real life?
>

It was pretty easy to reproduce in a stress test setup, where we spawn a
process, put it in a mem cgroup and setup the threshold, have it allocate a
lot of memory quickly (crossing the threshold), unregister the event, kill
and repeat. Usually within 30 mins.

>
> >
> > Fixed by only freeing after synchronize_rcu().
> >
>
> Fixes: 8c7577637ca3 ("memcg: free spare array to avoid memory leak")
> > Signed-off-by: Martijn Coenen <maco@google.com>
> Cc: stable
>
> Acked-by: Michal Hocko <mhocko@suse.com>
>
> Thanks!
>
> > ---
> >  mm/memcontrol.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 14cb1db..73228b6 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3522,16 +3522,17 @@ static void
> > __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
> >  swap_buffers:
> >       /* Swap primary and spare array */
> >       thresholds->spare = thresholds->primary;
> > -     /* If all events are unregistered, free the spare array */
> > -     if (!new) {
> > -             kfree(thresholds->spare);
> > -             thresholds->spare = NULL;
> > -     }
> >
> >       rcu_assign_pointer(thresholds->primary, new);
> >
> >       /* To be sure that nobody uses thresholds */
> >       synchronize_rcu();
> > +
> > +     /* If all events are unregistered, free the spare array */
> > +     if (!new) {
> > +             kfree(thresholds->spare);
> > +             thresholds->spare = NULL;
> > +     }
> >  unlock:
> >       mutex_unlock(&memcg->thresholds_lock);
> >  }
> > --
> > 2.6.0.rc2.230.g3dd15c0
>
> --
> Michal Hocko
> SUSE Labs
>

--94eb2c031094b6b66305294cdc07
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Jan 14, 2016 at 3:38 PM, Michal Hocko <span dir=3D"ltr">&lt;<a href=3D"=
mailto:mhocko@kernel.org" target=3D"_blank">mhocko@kernel.org</a>&gt;</span=
> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Thu 14-01-16=
 14:33:52, Martijn Coenen wrote:<br>
&gt; A spare array holding mem cgroup threshold events is kept around<br>
&gt; to make sure we can always safely deregister an event and have an<br>
&gt; array to store the new set of events in.<br>
&gt;<br>
&gt; In the scenario where we&#39;re going from 1 to 0 registered events, t=
he<br>
&gt; pointer to the primary array containing 1 event is copied to the spare=
<br>
&gt; slot, and then the spare slot is freed because no events are left.<br>
&gt; However, it is freed before calling synchronize_rcu(), which means<br>
&gt; readers may still be accessing threshold-&gt;primary after it is freed=
.<br>
<br>
</span>Have you seen this triggering in the real life?<br></blockquote><div=
><br></div><div>It was pretty easy to reproduce in a stress test setup, whe=
re we spawn a process, put it in a mem cgroup and setup the threshold, have=
 it allocate a lot of memory quickly (crossing the threshold), unregister t=
he event, kill and repeat. Usually within 30 mins.</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<span class=3D""><br>
&gt;<br>
&gt; Fixed by only freeing after synchronize_rcu().<br>
&gt;<br>
<br>
</span>Fixes: 8c7577637ca3 (&quot;memcg: free spare array to avoid memory l=
eak&quot;)<br>
&gt; Signed-off-by: Martijn Coenen &lt;<a href=3D"mailto:maco@google.com">m=
aco@google.com</a>&gt;<br>
Cc: stable<br>
<br>
Acked-by: Michal Hocko &lt;<a href=3D"mailto:mhocko@suse.com">mhocko@suse.c=
om</a>&gt;<br>
<br>
Thanks!<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; ---<br>
&gt;=C2=A0 mm/memcontrol.c | 11 ++++++-----<br>
&gt;=C2=A0 1 file changed, 6 insertions(+), 5 deletions(-)<br>
&gt;<br>
&gt; diff --git a/mm/memcontrol.c b/mm/memcontrol.c<br>
&gt; index 14cb1db..73228b6 100644<br>
&gt; --- a/mm/memcontrol.c<br>
&gt; +++ b/mm/memcontrol.c<br>
&gt; @@ -3522,16 +3522,17 @@ static void<br>
&gt; __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,<br>
&gt;=C2=A0 swap_buffers:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Swap primary and spare array */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0thresholds-&gt;spare =3D thresholds-&gt;prim=
ary;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0/* If all events are unregistered, free the spare=
 array */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (!new) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(thresholds-&gt;=
spare);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thresholds-&gt;spare =
=3D NULL;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0rcu_assign_pointer(thresholds-&gt;primary, n=
ew);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* To be sure that nobody uses thresholds */=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0synchronize_rcu();<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* If all events are unregistered, free the spare=
 array */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!new) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(thresholds-&gt;=
spare);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thresholds-&gt;spare =
=3D NULL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 unlock:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;memcg-&gt;thresholds_lock)=
;<br>
&gt;=C2=A0 }<br>
&gt; --<br>
&gt; 2.6.0.rc2.230.g3dd15c0<br>
<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Michal Hocko<br>
SUSE Labs<br>
</font></span></blockquote></div><br></div></div>

--94eb2c031094b6b66305294cdc07--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
