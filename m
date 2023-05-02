From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 19/40] change alloc_pages name in dma_map_ops to avoid
 name conflicts
Date: Tue, 2 May 2023 16:18:04 -0400
Message-ID: <ZFFv/IDprimshC8d@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-20-surenb@google.com>
 <20230502175052.43814202@meshulam.tesarici.cz>
 <CAJuCfpGSLK50eKQ2-CE41qz1oDPM6kC8RmqF=usZKwFXgTBe8g@mail.gmail.com>
 <20230502220909.3f55ae41@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683058694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhFW8Rae+PmqA9NsRu2fCLYsKzvllBF+D9enxFH2HZY=;
        b=hgtKk0MnzVAurVmwiCvBDIjIIIVHKWBblkqx4zQl8oTajKe75PQAIg3RUCa1kKrviBzNrJ
        GpiBkz7WRGs9kn6obwH3r112ivVqUTFRAFMnA9VjU9p6KvcxDCeLXwzxjYCGsLWrMrxgoJ
        DNMXVf2QpiAVCACDPy3H7fKlw3VRMxw=
Content-Disposition: inline
In-Reply-To: <20230502220909.3f55ae41@meshulam.tesarici.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andr

On Tue, May 02, 2023 at 10:09:09PM +0200, Petr Tesařík wrote:
> Ah, right, I admit I did not quite understand why this change is
> needed. However, this is exactly what I don't like about preprocessor
> macros. Each macro effectively adds a new keyword to the language.
> 
> I believe everything can be solved with inline functions. What exactly
> does not work if you rename alloc_pages() to e.g. alloc_pages_caller()
> and then add an alloc_pages() inline function which calls
> alloc_pages_caller() with _RET_IP_ as a parameter?

Perhaps you should spend a little more time reading the patchset and
learning how the code works before commenting.
