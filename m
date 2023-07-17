From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Mon, 17 Jul 2023 08:14:30 -0500
Message-ID: <op.1779qgkdwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-18-haitao.huang@linux.intel.com>
 <CU4GJG1NRTUD.275UVHM8W2VED@seitikki> <CU4GKARPLGU5.1CVBNY9N4K28F@seitikki>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689599679; x=1721135679;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=WXAAajyq7RVwSRDzE/5hqXM57XC+7i9ZvN34rS3CqAg=;
  b=YXzQdiEr2vtr6RoAmwmzKNNKFAebqPY8Lvj0Xvk3ad6W7GDIu7ASKxu/
   m9wFW3Zdhk9Y5fw9KPmOKvuK9L+q+p/3KjP3EyoQ4vGBBqmGlAuX1LXMt
   jHabnfE1QOfOMp9kDrNcofL1K5HCpVbQJXDdiR29nfSEOBa1vjlvPv8kz
   10Sxxr42K4nrzjm0FsLLFdrmMgiDwZPaKbd5QA67Mm6eOwS/6fgIX6jK7
   J6oi6GKEAUQykH0q1T6+5qJw3zpkx1nVEPBBTXILTVOJPNerEFXQb8IAM
   LppHtpXrm7DWSbo/K3XcIdpJaZ83AMnH7kqBbnB4WemmKJO0MXhdsye8M
   A==;
In-Reply-To: <CU4GKARPLGU5.1CVBNY9N4K28F@seitikki>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: Jarkko Sakkinen <jarkko@kernel.org>, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com

On Mon, 17 Jul 2023 07:49:27 -0500, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Mon Jul 17, 2023 at 12:48 PM UTC, Jarkko Sakkinen wrote:
>> On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
>> > Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
>> > worker) may reclaim SECS EPC page for an enclave and set
>> > encl->secs.epc_page to NULL. But the SECS EPC page is required for  
>> EAUG
>> > in #PF handler and is used without checking for NULL and reloading.
>> >
>> > Fix this by checking if SECS is loaded before EAUG and load it if it  
>> was
>> > reclaimed.
>> >
>> > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>>
>> A bug fix should be 1/*.
>
> And a fixes tag.
>
> Or is there a bug that is momentized by the earlier patches? This patch
> feels confusing to say the least.
>

It happens in heavy reclaiming cases, just extremely rare when EPC  
accounting is not partitioned into cgroups. Will add fix tag with the  
related EDMM patch. And move this as the first patch.

Thanks
Haitao

