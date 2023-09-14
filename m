From: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH v4 03/18] x86/sgx: Add sgx_epc_lru_lists to encapsulate
 LRU lists
Date: Thu, 14 Sep 2023 21:58:18 +0000
Message-ID: <df65414f2bb7a1a791ff8d7864640e34e52a8ef2.camel@intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
         <20230913040635.28815-4-haitao.huang@linux.intel.com>
         <851f9b3043732c17cd8f86a77ccee0b7c6caa22f.camel@intel.com>
         <7c418047-dd0b-76e9-dcfd-f00c76eeae46@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694728800; x=1726264800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LOuMN8tvenUpesB4CO60gSHHSVAvvLc4YgSsri/qM34=;
  b=GEv/ywbYCzbiy90gAqJgSeeyC27wsONt7lflzCk5uVFl35FwcDm4fZSk
   2iY9Nzy/IZSwtZoVQbkUL0c+ALVPWZhbGF8OOXxaC2WroWHZziU2S/ag6
   xCBUm3i8s9lQtHyw8Rc5z+E1gBPdFWOdgQ2akdvpSGvVYIpLr6nqATMwn
   wDZZf0WSrVHs8x099BZRppBmMBgNpfOVsBUbbwkXKoonSiv4AiPxqcPmD
   t4bmSSKvFf2mS4EPiQtoWUu/mRC7RPc8wTmjurNpqKUl+367l14ypBcDo
   AyMpZtvqpq45JhlqnBDLuhdjLbJnv8oYVQTrIfRnxFAedOIncS9mRWHq/
   A==;
In-Reply-To: <7c418047-dd0b-76e9-dcfd-f00c76eeae46@intel.com>
Content-Language: en-US
Content-ID: <B483E859C0629F4286D87420B111C526@namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "tj@kernel.org" <tj@kernel.org>, "Mehta, Sohil" <sohil.mehta@intel.com>, "mingo@redhat.com" <mingo@redhat.com>
Cc: "kristen@linux.intel.com" <kristen@linux.intel.com>, "anakrish@microsoft.com" <anakrish@microsoft.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Christopherson,, Sean" <seanjc@google.com>, "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "yangjie@microsoft.com" <yangjie@microsoft.com>, "Zhang, Bo" <zhanb@microsoft.com>

T24gVGh1LCAyMDIzLTA5LTE0IGF0IDA5OjEzIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8xNC8yMyAwMzozMSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IFNpZ25lZC1vZmYtYnk6
IEhhaXRhbyBIdWFuZyA8aGFpdGFvLmh1YW5nQGxpbnV4LmludGVsLmNvbT4NCj4gPiA+IENjOiBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gPiBZb3UgZG9uJ3QgbmVl
ZCAnQ2M6JyBTZWFuIGlmIHRoZSBwYXRjaCBoYXMgU2VhbidzIFNvQi4NCj4gDQo+IEl0IGlzIGEg
U29CIGZvciBTZWFuJ3MgQGludGVsIGFkZHJlc3MgYW5kIGNjJ3MgaGlzIEBnb29nbGUgYWRkcmVz
cy4NCj4gDQo+IEl0IGlzIGZpbmUuDQoNCk9vcHMgSSBkaWRuJ3Qgbm90aWNlIHRoZSBlbWFpbCBk
aWZmZXJlbmNlLiAgVGhhbmtzIGZvciBwb2ludGluZyBvdXQhDQo=
