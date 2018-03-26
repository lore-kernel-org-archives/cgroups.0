From: yuankuiz@codeaurora.org
Subject: Re: [PATCH]cgroup: __cpuset_node_allowed return bool
Date: Mon, 26 Mar 2018 22:37:31 +0800
Message-ID: <ea271bc26e293c232c6ea7772607c7fc@codeaurora.org>
References: <d2f9fe6096235032f445ab88e562560f@codeaurora.org>
 <0fee75e4a1b12f5fca30e04306a95788@codeaurora.org>
 <20180326141212.GI2149215@devbig577.frc2.facebook.com>
 <3540bc7869927f54c409b697c743938a@codeaurora.org>
 <20180326142527.GJ2149215@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1522075052;
        bh=Jlx+QtQD0W3uBFLNTZVr0aPkOlXCUQuhAalGWaitKiM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UBkcrBFlm4u308D47KUmAmaTaNmLD08+2Fba3zETTzdJIRlFUwB7jCgUSERwtF2eH
         s9Uko2nD4Oqi+HvfHjrc2T6iUc8cevw/p84fNaC0WGIPJQEkmAI4sFOVMVMsXPMrwU
         Ciwe+fbn16mrBhAA0TSIXLxk5+kLKmMQd2iwDcUY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1522075051;
        bh=Jlx+QtQD0W3uBFLNTZVr0aPkOlXCUQuhAalGWaitKiM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B8nHwutP0wi/sOOUHhyiOabgwq4B2RsnlhXLEKk57oFwsHUndCcSsPIXXIK7/Z9lC
         yYBFuB49ja5bwxMIyIJvoVPiW4kdkjHSb26ZNxvR0DjIB+OsjYJBj32nj219fGyoYa
         DuByoOFHcwxD/v3AJOLhMHwIL7XepsP+vNa7+e1g=
In-Reply-To: <20180326142527.GJ2149215@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, pkondeti@codeaurora.org, cgroups-owner@vger.kernel.org

Hi Tejun,

     inline.

On 2018-03-26 10:25 PM, Tejun Heo wrote:
> On Mon, Mar 26, 2018 at 10:20:43PM +0800, yuankuiz@codeaurora.org 
> wrote:
>>  1) return int type variable in bool function:
>>  bool enabled()
>>  {
>>  	int ret = 1;
>>  	return ret;
>>  }
> ...
>>  2)
>>  bool enabled()
>>  {
>>  	bool ret = 1;
>>  	return ret;
>>  }
> ...
>>  so the #1) style function can generate significant instructions
>> than the #2).
> 
> That is a problem for the compiler, not the code.
> 
>>  While, this is happened only when "-On" is not used with *-gcc
>> together. Though, it is oftern there, it is best to provide this
>> with decoupling of which option is used for optimization.
> 
> We don't want to dictate minute coding styles to avoid things which
> are trivially optimized by compilers.
[ZJ] Optimized by compiler is observed only. Such as it is not so big 
difference in x86-arch.

> 
> Thanks.
