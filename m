From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 08/18] memcg: infrastructure to match an allocation to
 the right cache
Date: Thu, 25 Oct 2012 11:08:12 -0700
Message-ID: <20121025180812.GN11442@htj.dyndns.org>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
 <1350656442-1523-9-git-send-email-glommer@parallels.com>
 <CAAmzW4N40MedsCfcj+eiM-i6cU65n3z7uy08YFyknXbBKj7Z-g@mail.gmail.com>
 <50891CF2.3030400@parallels.com>
 <20121025180652.GM11442@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4Vyg53IcPz0XksIephJsV4D5dNyMesfV2/NdaVr1Ybk=;
        b=s6VoXvtugz6Zp0f3JVAUS5/k9rldgu7F9LfbMwcWhSRxuUkDGlZs7VhdPZbyfn7qgQ
         JzYh8Q7KVi+ZwBRFan7V3e21SBNb2wdb6RC8w8wf+lykn8P350LvD15CkzNyq0l4aCJm
         8DwNlLBOTgocQ6fsL7UOy+X78XgQKCaOrGzOrqiAoGR+6v+P/8L75tUgRJDkUcgBUe8g
         nbeM80BZsE+PYwMXU8IMHy4ReN/VosrLOjwuNvg16iI8T33Jf8xJ0u10RPLJRIra+D6S
         vXzuVC0JOYviGi0DmrutgFK8tEKGLKwzXfi3P/cn+A5Uo29WPuianl47BLQbXKe0qiq4
         5XTQ==
Content-Disposition: inline
In-Reply-To: <20121025180652.GM11442@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: JoonSoo Kim <js1304@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Thu, Oct 25, 2012 at 11:06:52AM -0700, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Thu, Oct 25, 2012 at 03:05:22PM +0400, Glauber Costa wrote:
> > > Is there any rmb() pair?
> > > As far as I know, without rmb(), wmb() doesn't guarantee anything.
> > > 
> > 
> > There should be. But it seems I missed it. Speaking of which, I should
> 
> You probably can use read_barrier_depends().

Ooh, and when you use memory barrier pairs, please make sure to
comment on both sides explaining how they're paired and why.  There's
nothing more frustrating than barriers without clear annotation.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
