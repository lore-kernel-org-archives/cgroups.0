From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V4 5/6] memcg: patch mem_cgroup_{begin,end}_update_page_stat()
 out if only root memcg exists
Date: Sat, 13 Jul 2013 12:15:39 +0800
Message-ID: <CAFj3OHU3UQ=25J=PMa5qRzkVejN10e92x=nEbQh2s08A8Od7Uw@mail.gmail.com>
References: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
	<1373045623-27712-1-git-send-email-handai.szj@taobao.com>
	<20130711145625.GK21667@dhcp22.suse.cz>
	<CAFj3OHV=6YDcbKmSeuF3+oMv1HfZF1RxXHoiLgTk0wH5cJVsiQ@mail.gmail.com>
	<20130712132550.GD15307@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=20cf301cc4b04730ba04e15ce1c5
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=DcWwFyOMOw7DwMUierWrZ9tWutCvbICftLmaYticOug=;
        b=SzHwHhP98oqZ44pKWeJUNsu71EseCWh7iGKkWDtYAdngsWjjEyvaIHuchfSMKWeIhJ
         7xz4GoAFFn8QOkyur8nT2QZXFkvYXbm0IG/3tqoNXG9cDgvNgEr5dON3YkbDuZmNZhwJ
         WC5uPLrl6Rg73DWn7VKUffMDLebfII3z146k+0qMWpH/1epAL+ZgDv4/dDrn5zwrlWwh
         jAbSLbrgynrlLFkes9XiA83pw4xntgVMGvlwOIzTUZGzaili+qKlh6asQmbMon5N+iUb
         jGshkvNNreAZyyjcB1z1gy3FwAzcftaDSCLT5wyvJGPdf6bvK55VWHW/h+BD5qAjz20d
         apEw==
In-Reply-To: <20130712132550.GD15307@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Sha Zhengju <handai.szj@taobao.com>, Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

--20cf301cc4b04730ba04e15ce1c5
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

=D4=DA 2013-7-12 =CD=ED=C9=CF9:25=A3=AC"Michal Hocko" <mhocko@suse.cz>=D0=
=B4=B5=C0=A3=BA
>
> On Fri 12-07-13 20:59:24, Sha Zhengju wrote:
> > Add cc to Glauber
> >
> > On Thu, Jul 11, 2013 at 10:56 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > > On Sat 06-07-13 01:33:43, Sha Zhengju wrote:
> > >> From: Sha Zhengju <handai.szj@taobao.com>
> > >>
> > >> If memcg is enabled and no non-root memcg exists, all allocated
> > >> pages belongs to root_mem_cgroup and wil go through root memcg
> > >> statistics routines.  So in order to reduce overheads after adding
> > >> memcg dirty/writeback accounting in hot paths, we use jump label to
> > >> patch mem_cgroup_{begin,end}_update_page_stat() in or out when not
> > >> used.
> > >
> > > I do not think this is enough. How much do you save? One atomic read.
> > > This doesn't seem like a killer.
> > >
> > > I hoped we could simply not account at all and move counters to the
root
> > > cgroup once the label gets enabled.
> >
> > I have thought of this approach before, but it would probably run into
> > another issue, e.g, each zone has a percpu stock named ->pageset to
> > optimize the increment and decrement operations, and I haven't figure
out a
> > simpler and cheaper approach to handle that stock numbers if moving
global
> > counters to root cgroup, maybe we can just leave them and can afford th=
e
> > approximation?
>
> You can read per-cpu diffs during transition and tolerate small
> races. Or maybe simply summing NR_FILE_DIRTY for all zones would be
> sufficient.

Thanks, I'll have a try.

>
> > Glauber have already done lots of works here, in his previous patchset
he
> > also tried to move some global stats to root (
> > http://comments.gmane.org/gmane.linux.kernel.cgroups/6291). May I steal
> > some of your ideas here, Glauber? :P
> >
> >
> > >
> > > Besides that, the current patch is racy. Consider what happens when:
> > >
> > > mem_cgroup_begin_update_page_stat
> > >                                         arm_inuse_keys
> > >
mem_cgroup_move_account
> > > mem_cgroup_move_account_page_stat
> > > mem_cgroup_end_update_page_stat
> > >
> > > The race window is small of course but it is there. I guess we need
> > > rcu_read_lock at least.
> >
> > Yes, you're right. I'm afraid we need to take care of the racy in the
next
> > updates as well. But mem_cgroup_begin/end_update_page_stat() already
have
> > rcu lock, so here we maybe only need a synchronize_rcu() after changing
> > memcg_inuse_key?
>
> Your patch doesn't take rcu_read_lock. synchronize_rcu might work but I
> am still not sure this would help to prevent from the overhead which
> IMHO comes from the accounting not a single atomic_read + rcu_read_lock
> which is the hot path of mem_cgroup_{begin,end}_update_page_stat.

I means I'll try to zero out accounting overhead in next version, but the
race will probably also occur in that case.

Thanks!

>
> [...]
> --
> Michal Hocko
> SUSE Labs

--20cf301cc4b04730ba04e15ce1c5
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<p><br>
=D4=DA 2013-7-12 =CD=ED=C9=CF9:25=A3=AC&quot;Michal Hocko&quot; &lt;<a href=
=3D"mailto:mhocko@suse.cz">mhocko@suse.cz</a>&gt;=D0=B4=B5=C0=A3=BA<br>
&gt;<br>
&gt; On Fri 12-07-13 20:59:24, Sha Zhengju wrote:<br>
&gt; &gt; Add cc to Glauber<br>
&gt; &gt;<br>
&gt; &gt; On Thu, Jul 11, 2013 at 10:56 PM, Michal Hocko &lt;<a href=3D"mai=
lto:mhocko@suse.cz">mhocko@suse.cz</a>&gt; wrote:<br>
&gt; &gt; &gt; On Sat 06-07-13 01:33:43, Sha Zhengju wrote:<br>
&gt; &gt; &gt;&gt; From: Sha Zhengju &lt;<a href=3D"mailto:handai.szj@taoba=
o.com">handai.szj@taobao.com</a>&gt;<br>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt;&gt; If memcg is enabled and no non-root memcg exists, all al=
located<br>
&gt; &gt; &gt;&gt; pages belongs to root_mem_cgroup and wil go through root=
 memcg<br>
&gt; &gt; &gt;&gt; statistics routines. &nbsp;So in order to reduce overhea=
ds after adding<br>
&gt; &gt; &gt;&gt; memcg dirty/writeback accounting in hot paths, we use ju=
mp label to<br>
&gt; &gt; &gt;&gt; patch mem_cgroup_{begin,end}_update_page_stat() in or ou=
t when not<br>
&gt; &gt; &gt;&gt; used.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I do not think this is enough. How much do you save? One ato=
mic read.<br>
&gt; &gt; &gt; This doesn&#39;t seem like a killer.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I hoped we could simply not account at all and move counters=
 to the root<br>
&gt; &gt; &gt; cgroup once the label gets enabled.<br>
&gt; &gt;<br>
&gt; &gt; I have thought of this approach before, but it would probably run=
 into<br>
&gt; &gt; another issue, e.g, each zone has a percpu stock named -&gt;pages=
et to<br>
&gt; &gt; optimize the increment and decrement operations, and I haven&#39;=
t figure out a<br>
&gt; &gt; simpler and cheaper approach to handle that stock numbers if movi=
ng global<br>
&gt; &gt; counters to root cgroup, maybe we can just leave them and can aff=
ord the<br>
&gt; &gt; approximation?<br>
&gt;<br>
&gt; You can read per-cpu diffs during transition and tolerate small<br>
&gt; races. Or maybe simply summing NR_FILE_DIRTY for all zones would be<br=
>
&gt; sufficient.</p>
<p>Thanks, I&#39;ll have a try.</p>
<p>&gt;<br>
&gt; &gt; Glauber have already done lots of works here, in his previous pat=
chset he<br>
&gt; &gt; also tried to move some global stats to root (<br>
&gt; &gt; <a href=3D"http://comments.gmane.org/gmane.linux.kernel.cgroups/6=
291">http://comments.gmane.org/gmane.linux.kernel.cgroups/6291</a>). May I =
steal<br>
&gt; &gt; some of your ideas here, Glauber? :P<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Besides that, the current patch is racy. Consider what happe=
ns when:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; mem_cgroup_begin_update_page_stat<br>
&gt; &gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; arm_inuse_keys<br>
&gt; &gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
mem_cgroup_move_account<br>
&gt; &gt; &gt; mem_cgroup_move_account_page_stat<br>
&gt; &gt; &gt; mem_cgroup_end_update_page_stat<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; The race window is small of course but it is there. I guess =
we need<br>
&gt; &gt; &gt; rcu_read_lock at least.<br>
&gt; &gt;<br>
&gt; &gt; Yes, you&#39;re right. I&#39;m afraid we need to take care of the=
 racy in the next<br>
&gt; &gt; updates as well. But mem_cgroup_begin/end_update_page_stat() alre=
ady have<br>
&gt; &gt; rcu lock, so here we maybe only need a synchronize_rcu() after ch=
anging<br>
&gt; &gt; memcg_inuse_key?<br>
&gt;<br>
&gt; Your patch doesn&#39;t take rcu_read_lock. synchronize_rcu might work =
but I<br>
&gt; am still not sure this would help to prevent from the overhead which<b=
r>
&gt; IMHO comes from the accounting not a single atomic_read + rcu_read_loc=
k<br>
&gt; which is the hot path of mem_cgroup_{begin,end}_update_page_stat.</p>
<p>I means I&#39;ll try to zero out accounting overhead in next version, bu=
t the race will probably also occur in that case.</p>
<p>Thanks!</p>
<p>&gt;<br>
&gt; [...]<br>
&gt; --<br>
&gt; Michal Hocko<br>
&gt; SUSE Labs<br>
</p>

--20cf301cc4b04730ba04e15ce1c5--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
