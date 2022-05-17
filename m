From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RESEND][RFC PATCH] blkcg: rewind seq_file if no stats
Date: Tue, 17 May 2022 08:12:38 +0200
Message-ID: <20220517061238.GB4789@lst.de>
References: <CACGdZYLMW2KHVebfyJZVn9G=15N+Jt4+8oF5gq3wdDTOcXbk9A@mail.gmail.com> <20220513174030.1307720-1-khazhy@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20220513174030.1307720-1-khazhy@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Khazhismel Kumykov <khazhy@google.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, May 13, 2022 at 10:40:30AM -0700, Khazhismel Kumykov wrote:
> Restores the previous behavior of only displaying devices for which we
> have statistics (and removes the current, broken, behavior of printing
> devname with no newline if no statistics)
> 
> In lieu of get_seq_buf + seq_commit, provide a way to "undo" writes if
> we use seq_printf

I have to say I much prefer the simpler fix from Wolfgang.  But
if we want to go down this route it needs to split into a patch
for the seq_file infrastruture and a separate one for the blk-cgroup
code.
