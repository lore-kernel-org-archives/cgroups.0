From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Tue, 21 May 2019 12:31:08 -0400
Message-ID: <20190521163108.GB2591@mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
 <46c6a4be-f567-3621-2e16-0e341762b828@csail.mit.edu>
 <07D11833-8285-49C2-943D-E4C1D23E8859@linaro.org>
 <238e14ff-68d1-3b21-a291-28de4f2d77af@csail.mit.edu>
 <6EB6C9D2-E774-48FA-AC95-BC98D97645D0@linaro.org>
 <20190521091026.GA17019@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521091026.GA17019@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Paolo Valente <paolo.valente@linaro.org>, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, jmoyer@redhat.com, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com

On Tue, May 21, 2019 at 11:10:26AM +0200, Jan Kara wrote:
> > [root@localhost tmp]# dd if=/dev/zero of=/root/test.img bs=512 count=10000 oflag=dsync
> 
> Yes and that's expected. It just shows how inefficient small synchronous IO
> is. Look, dd(1) writes 512-bytes. From FS point of view we have to write:
> full fs block with data (+4KB), inode to journal (+4KB), journal descriptor
> block (+4KB), journal superblock (+4KB), transaction commit block (+4KB) -
> so that's 20KB just from top of my head to write 512 bytes...

Well, it's not *that* bad.  With fdatasync(), we're only having to do
this worse case thing every 8 writes.  The other writes, we don't
actually need to do any file-system level block allocation, so it's
only a 512 byte write to the disk[1] seven out of eight writes.

That's also true for the slice_idle hit, of course, We only need to do
a jbd2 transaction when there is a block allocation, and that's only
going to happen one in eight writes.

       	   	      	     	     	   - Ted

[1] Of course, small synchronous writes to a HDD are *also* terrible
for performance, just from the HDD's perspective.  For a random write
workload, if you are using disks with a 4k physical sector size, it's
having to do a read/modify/write for each 512 byte write.  And HDD
vendors are talking about wanting to go to a 32k or 64k physical
sector size...  In this sequential write workload, you'll mostly be
shielded from this by the HDD's cache, but the fact that you have to
wait for the bits to hit the platter is always going to be painful.
