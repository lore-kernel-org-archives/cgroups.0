From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] doc: cgroup: add f2fs and xfs to supported list for
 writeback
Date: Sun, 5 Jul 2020 14:35:37 -0600
Message-ID: <20200705143537.68055b16@lwn.net>
References: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, 29 Jun 2020 14:08:09 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> f2fs and xfs have both added support for cgroup writeback:
> 
> 578c647 f2fs: implement cgroup writeback support
> adfb5fb xfs: implement cgroup aware writeback
> 
> so add them to the supported list in the docs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> TBH I wonder about the wisdom of having this detail in
> the doc, as it apparently gets missed quite often ...

Good question, but as long as it's there it might as well be correct;
applied, thanks.

jon
