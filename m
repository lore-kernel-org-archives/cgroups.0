From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH] hugetlbfs: Add hugetlb_cgroup reservation limits
Date: Fri, 9 Aug 2019 13:38:54 -0700
Message-ID: <fc420531-f0fe-8df5-57fe-71a686bf2a71@oracle.com>
References: <20190808194002.226688-1-almasrymina@google.com>
 <20190809112738.GB13061@blackbody.suse.cz>
 <CAHS8izNM3jYFWHY5UJ7cmJ402f-RKXzQ=JFHpD7EkvpAdC2_SA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LYD1snKMlHvkWp294kI8LRCWSYWhhgJkoYcRSNCNcg8=;
 b=ezsCfB0ccRtKFM/FVNeNmizjTfDVi2F19OS3Pcd+azyflbwiFFJPY/w9RB71ws8Q4Bym
 5B0h67PGJ00hMzT1ZTbRWfis+fZ5Gi73ESPzQxqmuB8Ue7yd1woRPma7sgswrDd3HCYJ
 k5Q6XN7jr9Avwqjey9vnsER2Jl1jqW/PigjRLpnoCrkm1Q5EGr7HBphDkp+T6eMKFbna
 SFqJ18sx2NF52Im6q9ueeJYJnYCTSQP/FWjcn2F7bB5DBOuhfiUuTbpmVgEXUskqrPTi
 lqB1Pur98Db77Nrwb65JmqZtFWv2PtZ0fAMZLe9hf/EpKW/FKm/+oZCzhBG0yVw9ZTo0 VQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LYD1snKMlHvkWp294kI8LRCWSYWhhgJkoYcRSNCNcg8=;
 b=c9WzmLm8sd1JvJz89wNy75Btc6RYbJaGXeYI2l5NW4Bbk4gpxP2gx4i15t0OilFAbUjc
 6dA4vvinjOdft22mr9TBrukqtIgD2NE11HFTkc9+Md3xBB5hv4mwBKisT3nMKdZCy4lS
 9CAjTPRW/xhARtkzlaNCA7p797JFvfqsy8puQDc9w1daOmfOFMAQylUpJkVfwyjnP9yq
 Qb1eDDFmtg1Nfi8ningW6fEmvshpeXiCfY/LFI11v9DJihBj4Mx05mxNccPRsqdPXgef
 NWCzAGiba68jlgVuxyclXfBvD9ynmexYTMnSxil0vbvc9lc+q1mR1b1sc/tSdcvlCJxp Mg== 
In-Reply-To: <CAHS8izNM3jYFWHY5UJ7cmJ402f-RKXzQ=JFHpD7EkvpAdC2_SA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Mina Almasry <almasrymina@google.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

T24gOC85LzE5IDExOjA1IEFNLCBNaW5hIEFsbWFzcnkgd3JvdGU6Cj4gT24gRnJpLCBBdWcgOSwg
MjAxOSBhdCA0OjI3IEFNIE1pY2hhbCBLb3V0bsO9IDxta291dG55QHN1c2UuY29tPiB3cm90ZToK
Pj4+IEFsdGVybmF0aXZlcyBjb25zaWRlcmVkOgo+Pj4gWy4uLl0KPj4gKEkgZGlkIG5vdCB0cnkg
dGhhdCBidXQpIGhhdmUgeW91IGNvbnNpZGVyZWQ6Cj4+IDMpIE1BUF9QT1BVTEFURSB3aGlsZSB5
b3UncmUgbWFraW5nIHRoZSByZXNlcnZhdGlvbiwKPiAKPiBJIGhhdmUgdHJpZWQgdGhpcywgYW5k
IHRoZSBiZWhhdmlvdXIgaXMgbm90IGdyZWF0LiBCYXNpY2FsbHkgaWYKPiB1c2Vyc3BhY2UgbW1h
cHMgbW9yZSBtZW1vcnkgdGhhbiBpdHMgY2dyb3VwIGxpbWl0IGFsbG93cyB3aXRoCj4gTUFQX1BP
UFVMQVRFLCB0aGUga2VybmVsIHdpbGwgcmVzZXJ2ZSB0aGUgdG90YWwgYW1vdW50IHJlcXVlc3Rl
ZCBieQo+IHRoZSB1c2Vyc3BhY2UsIGl0IHdpbGwgZmF1bHQgaW4gdXAgdG8gdGhlIGNncm91cCBs
aW1pdCwgYW5kIHRoZW4gaXQKPiB3aWxsIFNJR0JVUyB0aGUgdGFzayB3aGVuIGl0IHRyaWVzIHRv
IGFjY2VzcyB0aGUgcmVzdCBvZiBpdHMKPiAncmVzZXJ2ZWQnIG1lbW9yeS4KPiAKPiBTbyBmb3Ig
ZXhhbXBsZToKPiAtIGlmIC9wcm9jL3N5cy92bS9ucl9odWdlcGFnZXMgPT0gMTAsIGFuZAo+IC0g
eW91ciBjZ3JvdXAgbGltaXQgaXMgNSBwYWdlcywgYW5kCj4gLSB5b3UgbW1hcChNQVBfUE9QVUxB
VEUpIDcgcGFnZXMuCj4gCj4gVGhlbiB0aGUga2VybmVsIHdpbGwgcmVzZXJ2ZSA3IHBhZ2VzLCBh
bmQgd2lsbCBmYXVsdCBpbiA1IG9mIHRob3NlIDcKPiBwYWdlcywgYW5kIHdpbGwgU0lHQlVTIHlv
dSB3aGVuIHlvdSB0cnkgdG8gYWNjZXNzIHRoZSByZW1haW5pbmcgMgo+IHBhZ2VzLiBTbyB0aGUg
cHJvYmxlbSBwZXJzaXN0cy4gRm9sa3Mgd291bGQgc3RpbGwgbGlrZSB0byBrbm93IHRoZXkKPiBh
cmUgY3Jvc3NpbmcgdGhlIGxpbWl0cyBvbiBtbWFwIHRpbWUuCgpJZiB5b3UgZ290IHRoZSBmYWls
dXJlIGF0IG1tYXAgdGltZSBpbiB0aGUgTUFQX1BPUFVMQVRFIGNhc2Ugd291bGQgdGhpcwpiZSB1
c2VmdWw/CgpKdXN0IHRoaW5raW5nIHRoYXQgd291bGQgYmUgYSByZWxhdGl2ZWx5IHNpbXBsZSBj
aGFuZ2UuCi0tIApNaWtlIEtyYXZldHoK
