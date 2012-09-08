From: Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Sat, 8 Sep 2012 09:36:29 -0400
Message-ID: <CAPhKKr8f6q=6m4T=-6PA8za-nMQMKy1HykAX-2NRaL9AZoPSjw@mail.gmail.com>
References: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
	<5047074D.1030104@parallels.com>
	<20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<50470A87.1040701@parallels.com>
	<20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<50470EBF.9070109@parallels.com>
	<20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<1346835993.2600.9.camel@twins>
	<20120905093204.GL3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<1346839487.2600.24.camel@twins>
	<20120906204642.GN29092@google.com>
	<CAPM31RKVYpkc0oTJKjsdsvqBfif=Bovi3a6TE8qdOOpEYOC0Lw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=hmINwVe0a40apzBjXrb4Uu5gKvCIhpX1iWlcQ0FZZgQ=;
        b=gJcHKRuT/k9aZgeCXRhyqcKoP/jo7n7TC8nVr7XWOd6aiyYbJgtmgV/lEVLltlBgdl
         3nbT3X+o7TqT/J+gM4cPqYxNGhsPRPcYR4basiuVa1C1qQf2DQk+0OqCTYVu1dZhhxdt
         fxHzgICl5ghVj67zV+M9C/Mkk54niGUa2eZpNuRePQuAHn5pw1Rp8Tf/HvmS0ilHgrG4
         Rus5o/nH/eu7t70nE/OKo8/4CYBn3qvBY0Fz2mbNJ8c96aRHP9ZcK3yURqhY7tg12CPi
         CYdGWqg8/L9A2Ik8jysRDvF9lRcaFKI5Shuv3iuqL0NbpCgChgr3zbFjny0vVtQzC4Oc
         bGQw==
In-Reply-To: <CAPM31RKVYpkc0oTJKjsdsvqBfif=Bovi3a6TE8qdOOpEYOC0Lw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt@google.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, lennart@poettering.net, kay.sievers@vrfy.org, Frederic Weisbecker <fweisbec@gmail.com>, Balbir Singh <bsingharora@gmail.com>, Bharata B Rao <bharata@linux.vnet.ibm.com>

On Thu, Sep 6, 2012 at 5:11 PM, Paul Turner <pjt@google.com> wrote:
> On Thu, Sep 6, 2012 at 1:46 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> cc'ing Dhaval and Frederic.  They were interested in the subject
>> before and Dhaval was pretty vocal about cpuacct having a separate
>> hierarchy (or at least granularity).
>
> Really?  Time just has _not_ borne out this use-case.  I'll let Dhaval
> make a case for this but he should expect violent objection.
>

I am not objecting directly! I am aware of a few users who are (or at
least were) using cpu and cpuacct separately because they want to be
able to account without control. Having said that, there are tons of
flaws in the current approach, because the accounting without control
is just plain wrong. I have copied a few other folks who might be able
to shed light on those users and if we should still consider them.

[And the lesser number of controllers, the better it is!]

Thanks!
Dhaval

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
