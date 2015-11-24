From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/8] cgroup: add function to get task's
	cgroup
Date: Tue, 24 Nov 2015 11:54:45 -0500
Message-ID: <20151124165445.GR17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-4-git-send-email-serge@hallyn.com>
 <20151124162728.GN17033@mtj.duckdns.org>
Reply-To: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-type:content-disposition:in-reply-to:user-agent;
 bh=b024LTq4OvS4xJg0sZO7Bk1NCYyvdbSX2hwZCOk2HXI=;
 b=L4L1zJ70sZH3JxlnN3gnBlUs9GbF4jF1KRTFA2i7RdvM/gJie31SxNgkczVs8gDvZP
 BKEbKv4/la9a+2fYRu9kj6MxmJS0z8vfjwNpRmSgMM/qevF5q9gN8mE9DYikWqErjVBD
 RKeT10zowiEbncdes4+yqYLZ5R9yimt+XfRZu/DlRx11D2uFB2m9EAFXdgRDYJO2kZPS
 PhGbZHrgf5fPXhJrNB3rxeMgC2qBgFh/bEbh4RQUWDn8n3QmRVlGVtSwUvPs+dTaRLH1
 Q7QXfjyydfFLrKA13rt4pBl4gI0SjAombG/FDwTM+j4U8w1rGoYkzUF1lEbp/MsakvJv
 HwvQ==
Content-Disposition: inline
In-Reply-To: <20151124162728.GN17033-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
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
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

T24gVHVlLCBOb3YgMjQsIDIwMTUgYXQgMTE6Mjc6MjhBTSAtMDUwMCwgVGVqdW4gSGVvIHdyb3Rl
Ogo+ID4gK3N0cnVjdCBjZ3JvdXAgKmdldF90YXNrX2Nncm91cChzdHJ1Y3QgdGFza19zdHJ1Y3Qg
KnRhc2spCgpVbW0uLi4gaXMgdGhpcyBmdW5jdGlvbiBldmVuIHVzZWQ/CgotLSAKdGVqdW4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbHhjLWRldmVsIG1h
aWxpbmcgbGlzdApseGMtZGV2ZWxAbGlzdHMubGludXhjb250YWluZXJzLm9yZwpodHRwOi8vbGlz
dHMubGludXhjb250YWluZXJzLm9yZy9saXN0aW5mby9seGMtZGV2ZWwK
