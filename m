From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 02/27] containers: Implement containers as kernel objects
Date: Tue, 19 Feb 2019 23:06:14 +0000
Message-ID: <19562.1550617574@warthog.procyon.org.uk>
References: <1550432358.2809.21.camel@HansenPartnership.com> <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk> <155024685321.21651.1504201877881622756.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550432358.2809.21.camel@HansenPartnership.com>
Content-ID: <19561.1550617574.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, trond.myklebust@hammerspace.com, sfrench@samba.org, linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, rgb@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> I thought we got agreement years ago that containers don't exist in
> Linux as a single entity: they're currently a collection of cgroups and
> namespaces some of which may and some of which may not be local to the
> entity the orchestration system thinks of as a "container".

I wasn't party to that agreement and don't feel particularly bound by it.

David
