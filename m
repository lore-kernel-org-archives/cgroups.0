From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v3 00/28] Add Cgroup support for SGX EPC memory
Date: Tue, 25 Jul 2023 12:16:06 -0500
Message-ID: <op.18nd84c7wjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <6bedc9fe-88b5-8382-aa65-ded66b58aa2c@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690305373; x=1721841373;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=acChHG7yYZ3Qqd5Vg1It58EizdosOgoh5agGHaDhu4o=;
  b=lBsDnsctn7FsqH7Q949bxMYiqpL+5ohu9V6c5Luc3qk5mslqyktsp8m3
   ZPMfXHzFOHAlxQzbOuyZuIWSXryMRbTCAKjnpj/TUbL7J7+KAk4tv4fLs
   JijIQl5SHvdhAztCleoZ5hUXJdoLIOFNeT2jb6k98+N89K5Jo0iuipNI4
   hddvqnAugFTNrwoPFZ6bQY07o6l+c5YHgNu8uklV/fb36AkMT1yeZRmc2
   4/DnL6zwEHx39TPquWwI+qQWtYR0Vk5QkOJ6UVEMnhKkU85DhicO2twca
   E2CGGs9btYfS3Hs6mBSZ97fT5ebQhVxJDIVGhEP4Z57KhvpLVBYK6wyJ6
   g==;
In-Reply-To: <6bedc9fe-88b5-8382-aa65-ded66b58aa2c@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, X86-kernel <x86@kernel.org>, Sohil Mehta <sohil.mehta@intel.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com

On Mon, 24 Jul 2023 14:09:21 -0500, Sohil Mehta <sohil.mehta@intel.com>  
wrote:

> Hi Haitao,
>
> On 7/12/2023 4:01 PM, Haitao Huang wrote:
>
>> I appreciate your comments and feedback.
>>
>
> Nit: You missed emailing the cover letter to x86@kernel.org. I think a
> few other people included in the individual patches are also missing in
> the cover letter.
>
> In general, it might be useful to keep the email list consistent across
> the cover letter and the individual patches.
>
> -Sohil

Thanks

I'll change to use the same set of lists and addresses for all patches and  
cover letters in next version.
BR
Haitao
