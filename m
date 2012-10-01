From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 02/15] cfq-iosched: More renaming to better represent wl_class and wl_type
Date: Mon, 01 Oct 2012 16:50:37 -0400
Message-ID: <x49r4phj4rm.fsf@segfault.boston.devel.redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349119976-26837-3-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:43 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org, cgroups@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Also at places I have got rid of keyword "serving" as it is obivious.

I don't agree with getting rid of serving.  After your patch, it looks
as though a cfqd has a static workload class and type.  It reads better
to me the way it is.

Cheers,
Jeff
