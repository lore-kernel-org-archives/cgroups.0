From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v3 09/16] sl[au]b: always get the cache from its page in
 kfree
Date: Fri, 21 Sep 2012 12:41:52 +0300 (EEST)
Message-ID: <alpine.LFD.2.02.1209211240410.3619@tux.localdomain>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-10-git-send-email-glommer@parallels.com> <00000139d9fe8595-8905906d-18ed-4d41-afdb-f4c632c2d50a-000000@email.amazonses.com> <5059777E.8060906@parallels.com>
 <CAOJsxLFgwOqUcLHEwYNERwn1Uvp4-8CmvRKTfBFAHD6p_-6c7g@mail.gmail.com> <505C33D3.5000202@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=Rc7R2XTbSZGEs4x4q8YpcLPyjKKGOvrKz9gii+cwCb8=;
        b=qWwCmee+9xnq2UKRpJFGfcCkJocAFjEqoIB6xDpab6HRasb4xxeBstLCVhCegXtzeL
         fQCRLTFjw2T1Ea/3Fo//bbef7tzCuppPx2RuDcXcpAvzUAElZ6hnbc2oKs9WCkOyy7Oq
         F1ZSTJfiKfilMqkv9ghroIMCz8Qu6wfS1AkixGrkDdfbSgRpVQitKB/Jqp+wQ2wAUb/t
         BJOool1t+AnTdIS5yc+qCgES4tEPy15wgPD2AWBL9CFjaE3gn9EOyoUbnLA9NF2Z0qo8
         jauYmEP26zTZTXAvCqfMef8T8QWHXW/MRsa3YAkHE5XPWdWshj3YJkEcGaktQkhkgicy
         e3nA==
In-Reply-To: <505C33D3.5000202@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>

On Fri, 21 Sep 2012, Glauber Costa wrote:
> > We should assume that most distributions enable CONFIG_MEMCG_KMEM,
> > right? Therfore, any performance impact should be dependent on whether
> > or not kmem memcg is *enabled* at runtime or not.
> > 
> > Can we use the "static key" thingy introduced by tracing folks for this?
>
> Yes.
> 
> I am already using static keys extensively in this patchset, and that is
> how I intend to handle this particular case.

Cool.

The key point here is that !CONFIG_MEMCG_KMEM should have exactly *zero* 
performance impact and CONFIG_MEMCG_KMEM disabled at runtime should have 
absolute minimal impact.

			Pekka

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
