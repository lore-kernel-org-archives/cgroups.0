Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635057;
	b=TdAmtQGCU2DJ9rm5dzAneiv0ySDOxMxHTZfR7lC1/uBkwYsomHb70S/N0qkMsXjI+Vsu
	 lclzoFw7tUkPKNrSZmcjmjQpPbTu9gxsJEbO46siUcQRUONjuDJ1tLJw8vJ08zZlghRzq
	 qHJ58T4ogKTzTjcTerHBqK6tubSYN/SrKYAaXFn0Z3qzi+c7Ye9kxD7ckzhAeagKmI/yC
	 GePiS27lj6Ya/9zzviGiAWwYRqfkhFKJnYBxuUJtaKoUny2Gn1LLIWPi3OkN01w02jXDW
	 tTz7LJyHULdDzswlE0sphZhB+oyQU+SNAxIwQXxInmd6lWEhIfeWZVkNizy1J8nGbyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635057;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=nmjX+gZnq1JmQb9kEyFBLchOqDlgvPlEFS1E5xvlvxE=;
	b=sG19DlMRjFvWujo0Hmlk0VhCt2KR1bsX2OWg4J5T6AKTt/uC0rl/TTqAbsKW5Z7mQxnF
	 9vbUuzFVCjflnGTyepi27frq0f8k1owRGgTL0rvKxnvNftrLmJffHjFWxBQ24lqbjpWtu
	 dwTPXX/f8JkpJCz879sgwas9koUSY//9AxYfSLw7a3d00LpZqTsG2bSjn4GD06TlVv1EQ
	 EIWkDdojBZu8iTfm9jAk3yVjFrDJqPe0f9sOo0Qr9LoOUs7CDRuEOnkASWDQsYahOAIwN
	 oGLnIQqe44QxUQAVVesa2xLV3QQRyxr+pL9hOJL4QA2QsfMCrGsmERviJpFgvXFx5eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fnGlHX+U;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEA8606A5B2;
	Mon,  2 Nov 2026 15:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FEA8606A5B2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fnGlHX+U
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06AA11691;
	Mon,  2 Nov 2026 07:57:33 -0800 (PST)
Received: from [10.57.66.79] (unknown [10.57.66.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B8703F673;
	Mon,  2 Nov 2026 07:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793635056; bh=17j2yXfs58CpqKQEHFy6H451nac5qtYTTRF17xOQiSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fnGlHX+UPMKGBP4eiXdt3RMc/CD0IYMClJYY6xjctAvQ6jZVSB9jGzI//Eeq8Tlp1
	 b5pFugq0mn9nU1RHNbvkKV4aYN7E24deQtMM8+tufCWNMZWa39mw5yvvqiRx4GIOMG
	 XfBRk/rotWv3ZIXj8FtfUybUKIm4ZQabM2yXAqlk=
Message-ID: <46c28259-086e-4948-8c00-183f9e62114a@arm.com>
Date: Mon, 2 Nov 2026 15:57:33 +0000
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
Content-Language: en-GB
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-2-enju.kohei@fujitsu.com>
 <46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com>
 <amwrnJ1KhllC-gVu@FCCLS0092175.localdomain>
 <auio781Uu9Zzyq3i@FCCLS0092175.localdomain>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <auio781Uu9Zzyq3i@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kohei,

On 02/11/2026 15:19, Kohei Enju wrote:
> Hi Suzuki,
> 
> I sent the message below off-list a few weeks ago, but I'm following up
> on-list in case it didn't reach you.
> 
> Since then, I've started reworking the series based on the
> kvm_device_attr approach you suggested, and I'm currently testing it
> against v23 of the CCA host support.
> 
> I'd still appreciate any feedback on the ABI direction, as well as
> whether you see any concerns with posting the RFC series while the host
> support is not yet upstream.
> 
> Thanks,
> Kohei
> 
> On Fri, Oct 9, 2026 at 03:15:23PM +0900, Kohei Enju wrote:
>> On 07/31 14:09, Kohei Enju wrote:
>>> On 07/29 12:47, Suzuki K Poulose wrote:
>>>> Hello
>>>>
>>>> Thanks for sending the patch. Please find my comments inline below.
>>>>
>>>>
>>>> On 24/07/2026 10:40, Kohei Enju wrote:
>>>>> Introduce the KVM_ARM_RMI_CONFIG ioctl to allow userspace to configure
>>>>> Realm VM parameters before the Realm is created.
>>>>
>>>> This approach is something we tried in the past. Another option is to
>>>> add these as kvm_device_attr for the KVM VM, under a new group, e.g.,
>>>> KVM_ARM_VM_RMI_CTRL and add the following attributes :
>>>>
>>>> KVM_ARM_VM_RMI_CTRL_RPV 		-> Realm Personalization Value
>>>> KVM_ARM_VM_RMI_CTRL_MEASUREMENT_ALGO	-> Measuerment algo
>>>> KVM_ARM_VM_RMI_CTRL_MEC_PRIVATE		-> Private MEC Policy. By default to shared
>>>> ?
>>>
>>> Hi Suzuki, thanks for suggesting another option. That looks good to me,
>>> and I'd be happy with either approach.
>>> Anyway I'd like to wait for feedback from the maintainers and other
>>> reviewers.
>>
>> Hi Suzuki,
>>
>> I'm thinking of respinning the MEC policy series as RFC v2, as you
>> mentioned in the Core Collective WG last month.
>>
>> For the ABI, I'm planning to switch to the kvm_device_attr-based
>> approach you suggested instead of introducing a new VM ioctl. Before I
>> start reworking the series, do you have any concerns with that
>> direction?

...


>>
>> One other point is that the series still depends on the CCA host
>> support, which is not upstream yet. As a result, tools such as Sashiko
>> would likely be unable to identify the correct base tree and may not be
>> able to provide useful automated review feedback.
>>
>> Personally, I think this is acceptable since the series is still RFC and
>> the primary goal is to get feedback on the ABI and overall design rather
>> than seeking integration at this stage. However, I am aware that posting
>> patches on top of non-upstream trees can sometimes be problematic from a
>> review perspective.
>>
>> Do you have any concerns about posting an RFC series in this situation,
>> or would you prefer that I wait until the host support lands upstream?

It would be useful to have the RFC on the list to get an idea on shaping
the UABI. It may also be useful for people to verify the end-to-end
stack, including the remote attestation flow. (the branch we have is
ancient)

But nothing else, i.e, code correctness or functional reviews
etc (that rules out meaningful Sashiko reviews etc).

Suzuki



>>
>> Thanks,
>> Kohei

