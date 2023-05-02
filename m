From: Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Tue, 02 May 2023 10:55:47 +0300
Message-ID: <877ctr2mm4.fsf@intel.com>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683014170; x=1714550170;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=nrkr4HYmMNERiR03z1fTM4+8ZBGmodVVyRAkn4iTZe4=;
  b=iA1CKD9QN/r5BedDyY96UN8tEqmADQ8p/7gWi0GV/hZg/dWYsvbDKHMq
   33vb2IpxrE1rAveWR9F7Z1IYquO5t65yUi9FLPwi9LRq3f06Sosy/sqoR
   a6+HAEYb/2sJC5u5rv4iUAuURiqvgxGYB4nMevSeNFn6gUsl6pxIZMVBF
   M1jkSVzwLlGtyBRb3TUyT9qHHp32yL9v+hHMAyERpTAN5q+0q8yDFxBHk
   Xo/es4qt5ZESY7ksYC9Z8pqSYfuuSxyWRlPzg7MjeRsEKnFGtDdb3ZGzd
   7rT9sPR44NwgT5PZGYcjIMbeQOX06tmfleBeXBPDeTc99TD6PKVof79XY
   Q==;
In-Reply-To: <20230501165450.15352-2-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

On Mon, 01 May 2023, Suren Baghdasaryan <surenb@google.com> wrote:
> From: Kent Overstreet <kent.overstreet@linux.dev>
>
> Previously, string_get_size() outputted a space between the number and
> the units, i.e.
>   9.88 MiB
>
> This changes it to
>   9.88MiB
>
> which allows it to be parsed correctly by the 'sort -h' command.

The former is easier for humans to parse, and that should be
preferred. 'sort -h' is supposed to compare "human readable numbers", so
arguably sort does not do its job here.

BR,
Jani.

>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Andy Shevchenko <andy@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "Noralf Tr=C3=B8nnes" <noralf@tronnes.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  lib/string_helpers.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> index 230020a2e076..593b29fece32 100644
> --- a/lib/string_helpers.c
> +++ b/lib/string_helpers.c
> @@ -126,8 +126,7 @@ void string_get_size(u64 size, u64 blk_size, const en=
um string_size_units units,
>  	else
>  		unit =3D units_str[units][i];
>=20=20
> -	snprintf(buf, len, "%u%s %s", (u32)size,
> -		 tmp, unit);
> +	snprintf(buf, len, "%u%s%s", (u32)size, tmp, unit);
>  }
>  EXPORT_SYMBOL(string_get_size);

--=20
Jani Nikula, Intel Open Source Graphics Center
