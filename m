From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/6] sched: Add get_current_state()
Date: Wed, 2 Jun 2021 16:12:30 +0200
Message-ID: <YLeRzlEmbdsMrFcG@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.461908001@infradead.org>
 <1731339790.5856.1622642489232.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kgdb-bugreport-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=FzJfBljo4B8RxU2ilIDhSLr34HFST0rQLNCYNw/HW+w=; b=YCeecF0sL2ibRbFptkBep349kP
 QT/eL/27nuzrdOs0Eh10NsNI+uh6ffDs23ByXTWjImy4HoqKHOMEHnpvpZZuw2x47mPA5wHjrVmbe
 Dj3rBrb9x73RRapJgLPSiW7UCGROGsM8HKFuG4h03GEirruVrxp00HbWX7qEfpqUf+UE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=FzJfBljo4B8RxU2ilIDhSLr34HFST0rQLNCYNw/HW+w=; b=NA9nXszPU1DFaIaOmeO4v4lVSI
 TdMGcV9zrZx+J8xk3D3SmHKQ46mJIbuBG0tPHng6XWorvH8AT533vC+ghKkPZGBzP8vUasMU5D07A
 rYFznNJd+zugX9A3K+iDV27vHm3ijE58mDrUfetrUxStIVfHSRpqxLkeFMTqBsmKnvsI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=FzJfBljo4B8RxU2ilIDhSLr34HFST0rQLNCYNw/HW+w=; b=L9vjUarjZTu6NzihPxyvfr9SrD
 cXp2K8L/lswul4alVU9a5KXYcmiYKaI0pVqEPrOTObk1bWVjIa727CcohFhQnptUDt9rVM7+wZokD
 bdiAP5TkdYqfBQHbyzuL3QwjL5RpkYojkJ5M5vFeN5hhURZOWxGVnCDXhqvgtesERKVZoPVmmu+1u
 zvBuQ/5U6yi+c+8BHLKEGRhN8+mOxmjvdNXmQvv5K7kABrgsWq6TQpgiZuniSUsdWGatjG0TQN4HN
 iyi9j9XYfQaN+mhBZrOglYAeu1Bmuw53jmWdaNNlHNX9gCtb8Ta+n9yUYscEboZQaYK4WTzPQHe3/
 3aLE6Hfw==;
Content-Disposition: inline
In-Reply-To: <1731339790.5856.1622642489232.JavaMail.zimbra@efficios.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/kgdb-bugreport>, 
 <mailto:kgdb-bugreport-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=kgdb-bugreport>
List-Post: <mailto:kgdb-bugreport@lists.sourceforge.net>
List-Help: <mailto:kgdb-bugreport-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kgdb-bugreport>, 
 <mailto:kgdb-bugreport-request@lists.sourceforge.net?subject=subscribe>
Errors-To: kgdb-bugreport-bounces@lists.sourceforge.net
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Juri Lelli <juri.lelli@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>, Lai Jiangshan <jiangshanlai@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Ben Segall <bsegall@google.com>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, "H. Peter Anvin" <hpa@zytor.com>, "Joel Fernandes, Google" <joel@joelfernandes.org>, netdev <netdev@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>, Alasdair Kergon <agk@redhat.com>, Daniel Thompson <daniel.thompson@linaro.org>, Davidlohr Bueso <dave@stgolabs.net>, Vincent Guittot <vincent.guittot@linaro.org>, KVM list <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>, cgroups <cgroups@v>

On Wed, Jun 02, 2021 at 10:01:29AM -0400, Mathieu Desnoyers wrote:
> ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:
> 
> > Remove yet another few p->state accesses.
> 
> [...]
> 
> > 
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -212,6 +212,8 @@ struct task_group;
> > 
> > #endif
> > 
> > +#define get_current_state()	READ_ONCE(current->state)
> 
> Why use a macro rather than a static inline here ?

Mostly to be consistent, all that state stuff is macros. I suppose we
could try and make them inlines at the end or so -- if the header maze
allows.
