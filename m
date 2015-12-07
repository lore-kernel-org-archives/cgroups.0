From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside
 non-init cgroupns
Date: Mon, 7 Dec 2015 10:39:11 -0500
Message-ID: <20151207153911.GF9175@mtj.duckdns.org>
References: <20151130150938.GF3535@mtj.duckdns.org>
 <20151201040704.GA31067@mail.hallyn.com>
 <20151201164649.GD12922@mtj.duckdns.org>
 <20151201215853.GA9153@mail.hallyn.com>
 <20151202165312.GB19878@mtj.duckdns.org>
 <20151202165637.GA20840@mail.hallyn.com>
 <20151202165839.GD19878@mtj.duckdns.org>
 <20151202170239.GA21009@mail.hallyn.com>
 <20151202170551.GE19878@mtj.duckdns.org>
 <20151203224706.GA19971@mail.hallyn.com>
Reply-To: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-type:content-disposition:in-reply-to:user-agent;
 bh=NW+bwqD95wzcvH30QdEvKVdxGqDYjKDSjL4fW52esg8=;
 b=sIKkLJvbuQG+g8PYzilg3zlvHXtVCp0tqM14GeXHOqEvGwBR559OWL4OdpLxopMd86
 fzUJssZp5iQigyotmn7TvXTNP64PWjiZhlw9b2uvMNNcXs7TuD+NEAkjua2GnD7ozAPS
 Lx6FdI58udlMKBpHLLOuG12JUH0y7kV5TNBB+vS+mFJ9xwny5RL0kFeOO3wpfi31Tyke
 5XFvvUaTbTYxWJRHARNIo2//63UE+rGLxWGiBPf9iEco8rcslty8e3WNqqR8R4EEFI6p
 skqqK0MhiJOAHeZO188rnZ43wgxDM0ItD1uT0QbmJK7921OMdlhA1Ka3r29Vf2YEbmRM
 exwQ==
Content-Disposition: inline
In-Reply-To: <20151203224706.GA19971-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.linuxcontainers.org/options/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxcontainers.org/pipermail/lxc-devel/>
List-Post: <mailto:lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
List-Help: <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linuxcontainers.org/listinfo/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org
Sender: "lxc-devel" <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

SGVsbG8sIFNlcmdlLgoKT24gVGh1LCBEZWMgMDMsIDIwMTUgYXQgMDQ6NDc6MDZQTSAtMDYwMCwg
U2VyZ2UgRS4gSGFsbHluIHdyb3RlOgouLi4KPiArCWRlbnRyeSA9IGRnZXQoc2ItPnNfcm9vdCk7
Cj4gKwlpZiAoIWtuLT5wYXJlbnQpIC8vIHRoaXMgaXMgdGhlIHJvb3QKPiArCQlyZXR1cm4gZGVu
dHJ5Owo+ICsKPiArCWtucGFyZW50ID0gZmluZF9rbl9hbmNlc3Rvcl9iZWxvdyhrbiwgTlVMTCk7
Cj4gKwlCVUdfT04oIWtucGFyZW50KTsKCkRvaW5nIFdBUk5fT04oKSBhbmQgcmV0dXJuaW5nIGZh
aWx1cmUgaXMgYmV0dGVyLCBJIHRoaW5rLiAgRmFpbGluZyBucwptb3VudCBpcyBhbiBva2F5IGZh
aWx1cmUgbW9kZSBhbmQgYSBsb3QgYmV0dGVyIHRoYW4gY3Jhc2hpbmcgdGhlCnN5c3RlbS4gIEFs
c28sIGhvdyBhYm91dCBmaW5kX25leHRfYW5jZXN0b3IoKSBmb3IgdGhlIG5hbWUgb2YgdGhlCmZ1
bmN0aW9uPwoKPiArCWRvIHsKPiArCQlzdHJ1Y3QgZGVudHJ5ICpkdG1wOwo+ICsJCXN0cnVjdCBr
ZXJuZnNfbm9kZSAqa250bXA7Cj4gKwo+ICsJCWlmIChrbiA9PSBrbnBhcmVudCkKPiArCQkJcmV0
dXJuIGRlbnRyeTsKPiArCQlrbnRtcCA9IGZpbmRfa25fYW5jZXN0b3JfYmVsb3coa24sIGtucGFy
ZW50KTsKPiArCQlCVUdfT04oIWtudG1wKTsKPiArCQlkdG1wID0gbG9va3VwX29uZV9sZW4oa250
bXAtPm5hbWUsIGRlbnRyeSwgc3RybGVuKGtudG1wLT5uYW1lKSk7Cj4gKwkJZHB1dChkZW50cnkp
Owo+ICsJCWlmIChJU19FUlIoZHRtcCkpCj4gKwkJCXJldHVybiBkdG1wOwo+ICsJCWtucGFyZW50
ID0ga250bXA7Cj4gKwkJZGVudHJ5ID0gZHRtcDsKPiArCX0gd2hpbGUgKDEpOwoKT3RoZXIgdGhh
biB0aGUgbml0cGlja3MsIGxvb2tzIGdvb2QgdG8gbWUuCgpUaGFua3MuCgotLSAKdGVqdW4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbHhjLWRldmVsIG1h
aWxpbmcgbGlzdApseGMtZGV2ZWxAbGlzdHMubGludXhjb250YWluZXJzLm9yZwpodHRwOi8vbGlz
dHMubGludXhjb250YWluZXJzLm9yZy9saXN0aW5mby9seGMtZGV2ZWwK
