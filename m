From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] blkcg: remove unused __blkg_release_rcu()
Date: Thu, 20 Dec 2018 17:08:17 +0000
Message-ID: <f23e7319-307d-df88-4bad-0e9f71331677@fb.com>
References: <20181219224353.32763-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cMcXGK4vCoYqSAoydb+ELhPwhzqXjOIP/gleJ+dLsFE=;
 b=BqEcoubBDKEdEoDGxqORKBA7SQh8vezbEfhdEQoPHwUCRWTn2PtkIskXqtrhhVw5Cv9u
 716n26kVnZLxIGpXj3a+F8ko/cZrmtdM1XDJ4mEbtqBOWmRPcei7YwbtxmuwDvwBJTS8
 SdkROAqHllmafR0noGsmp7emhOm1urcrO/g= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMcXGK4vCoYqSAoydb+ELhPwhzqXjOIP/gleJ+dLsFE=;
 b=hf41rUaOQPbyd75HMHy8dhkZHydHHRUodnv8tuDkHMCI/SFSA2rzazzSOTg/Sq0MuBR/P0DPTM3b3tq3xRLti5K+tLv1idQQ/LEv0c1E6vNY/tFNOOwmawYrxvLWu4ra9WVFo9if9jQmzvo1xExhSfh5EFUmrTfnheojbe5HWMQ=
In-Reply-To: <20181219224353.32763-1-dennis@kernel.org>
Content-Language: en-US
Content-ID: <FDD3FCFA0EDEDF49BC60965D69A44107@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Kernel Team <Kernel-team@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

T24gMTIvMTkvMTggMzo0MyBQTSwgRGVubmlzIFpob3Ugd3JvdGU6DQo+IEFuIGVhcmxpZXIgY29t
bWl0IDdmY2YyYjAzM2I4NCAoImJsa2NnOiBjaGFuZ2UgYmxrZyByZWZlcmVuY2UgY291bnRpbmcN
Cj4gdG8gdXNlIHBlcmNwdV9yZWYiKSBtb3ZlZCBhcm91bmQgdGhlIHJlbGVhc2UgY2FsbCBmcm9t
IGJsa2dfcHV0KCkgdG8gYmUNCj4gYSBwYXJ0IG9mIHRoZSBwZXJjcHVfcmVmIGNsZWFudXAuIFJl
bW92ZSB0aGUgYWRkaXRpb25hbCB1bnVzZWQgY29kZQ0KPiB3aGljaCBzaG91bGQgaGF2ZSBiZWVu
IHJlbW92ZWQgZWFybGllci4NCg0KQXBwbGllZCBmb3IgNC4yMSwgdGhhbmtzLg0KDQotLSANCkpl
bnMgQXhib2UNCg0K
