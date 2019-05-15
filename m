From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] signal: don't always leave task frozen after
 ptrace_stop()
Date: Wed, 15 May 2019 16:43:35 +0200
Message-ID: <20190515144335.GC18892@redhat.com>
References: <20190513195517.2289671-1-guro@fb.com>
 <20190514160158.GB32459@redhat.com>
 <20190514174603.GB12629@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190514174603.GB12629@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Alex Xu <alex_y_xu@yahoo.ca>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 05/14, Roman Gushchin wrote:
>
> I agree that "may_remain_frozen" adds a lot of ugliness, so let's fix
> the regression with the unconditional leave_frozen(true). The patch below.
> Please, let me know if it's not what you meant.

Yes, thanks, this is what I meant. Feel free to add my ACK.

> so it's good only as a temporarily solution. But it looks like we agree here.

Yes, yes.

Oleg.

