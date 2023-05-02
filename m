From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Mon, 1 May 2023 20:53:35 -0400
Message-ID: <ZFBfD96zDCh2RcVN@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan>
 <CAHp75VeJ_a6j3uweLN5-woSQUtN5u36c2gkoiXhnJa1HXJdoyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682988827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HE6/29tmaJsag6zI8A6kmxQ69S3GfTZnUjmZGEHLawo=;
        b=ci4cChjLz5Nx1p0M1HRMt5So3sz9KA0GgxxfJ3Xwor6CW087TfNJ7iQTl4/3c0JNtoSbDN
        lpQ8ZWLAifEJkjQ0tAmFUrtzJU1c3/fVq5bvHHW3PTJu3ar2FleeqU5hFkYQxLtn/8ayrd
        /Rktc0wIh6rpWmQBBJpcnipz4wb3Wbs=
Content-Disposition: inline
In-Reply-To: <CAHp75VeJ_a6j3uweLN5-woSQUtN5u36c2gkoiXhnJa1HXJdoyQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, k

On Mon, May 01, 2023 at 10:57:07PM +0300, Andy Shevchenko wrote:
> But why do we need that? What's the use case?

It looks like we missed you on the initial CC, here's the use case:
https://lore.kernel.org/linux-fsdevel/ZFAsm0XTqC%2F%2Ff4FP@P9FQF9L96D/T/#mdda814a8c569e2214baa31320912b0ef83432fa9
