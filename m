From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 04/18] x86/sgx: Use sgx_epc_lru_lists for existing
 active page list
Date: Fri, 2 Dec 2022 14:10:16 -0800
Message-ID: <e71d76b2-4368-4627-abd4-2163e6786a20@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-5-kristen@linux.intel.com>
 <ad1bcb0f-661d-a701-2175-c8750d8af8d8@intel.com>
 <d17c270bcbf631736d52b762dad8a6758d7dc951.camel@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670019025; x=1701555025;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kff4S1vyf+hWj1GXzPubNZckk1uQ/dFn8K1E9qFptjk=;
  b=gMvbzBqDLpKA5i7dJC5HoH5F16MU8pJNXCZDNhEAVrL+cb9y/ookBjcp
   lnmlJYY10vLIX332z1gctOlnVNGCIKruFWyQk5PmK+jSWDUWRcud2GVmf
   X1sgm23k4qb17CGnU0pWsSi7Kxe8rui5235qqnxCoSpLU7nzug+jAWSe0
   2oaFVJ0niQSlQ8ZXV8uxSFhUjyAULFCFrV3WXYGB3AYBxZTBpCZpETrEY
   yYlNtDDxToA1bWMVYgFu7C/HhOzXf/WAe5eFRZa/E1kA+MMr2VVtxPn3E
   8/jbDCwebvsUSy9SbbMr/JTlr4K8vqweoVgv9K8yqARU1gNZccWYqRqMg
   w==;
Content-Language: en-US
In-Reply-To: <d17c270bcbf631736d52b762dad8a6758d7dc951.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 13:51, Kristen Carlson Accardi wrote:
> I know - and originally the addition of unreclaimable was added later,
> but when I posted the RFC I felt there was some misunderstanding about
> what this data structure was and how it would be used because the
> addition of the unreclaimable bits came later. So I stuck both lists in
> one so it'd be a better view of what the data structure would look
> like.

You're not insane for thinking that.

But, it's really OK to introduce an abstraction that *looks* silly on
its face at first.  You can easily just make up for it by saying:

	struct silly_abstraction {
		struct list_head list;
	}

	Oh, boy does my structure look silly.  It's a structure with a
	single list_head.  Why oh why would I do something silly like
	that?  Well, for now, the code has but one list.  Soon, I'll
	add a whole smorgasbord of lists.  Bear with me for now.

