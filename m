From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v3 22/28] Docs/x86/sgx: Add description for cgroup support
Date: Fri, 14 Jul 2023 15:26:38 -0500
Message-ID: <op.1729qobwwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-23-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689366402; x=1720902402;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=hN1j+GFrFTi2sMdb0x6EvEauXOQiHe+xtthEmkTSYxI=;
  b=bisEsH+RDsJv3bzPwySZf3SxqsJzyymVWfNewe80yQEgKrvhaMOUQSZw
   +pQNIHO2r1xq4iJaB7fZ2m3tvYXCCWJqLP36rNudlfGwKXth4LfECZsxG
   O2hutCfIaMR4nQob3CAE0PgR67Q4AHshG6KCdIsT88iZ7otFwCLOfVnQW
   UREH6/xjlc9/eQdrB+szPx8c5YJcRXQotuawhYude4YWIqNFcZe0qPnfS
   DK1Bo9zVmiMSfTkYn/bSgjKUIdajkP9VzGj9JKO8DVj3gmu7DFiUnPlFa
   4RspIqvr3hGYB9/xgxWYjABYq+cEiYuT5r1237rMQDSe+91NgSGyE+N3Q
   Q==;
In-Reply-To: <20230712230202.47929-23-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Haitao Huang <haitao.huang@linux.intel.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, Kristen Carlson Accardi <kristen@linux.intel.com>, zhiquan1.li@intel.com, seanjc@google.com, bagasdotme@gmail.com, linux-doc@vger.kernel.org, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com


> +
> +  misc.events
> +	A read-write flat-keyed file which exists on non-root cgroups.

It's actually read-only for this file. Will fix.

Haitao
