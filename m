From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Wed, 22 May 2019 03:02:25 -0700
Message-ID: <ebe43a35-87d3-11c6-5928-3f90055367ed@csail.mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
 <46c6a4be-f567-3621-2e16-0e341762b828@csail.mit.edu>
 <07D11833-8285-49C2-943D-E4C1D23E8859@linaro.org>
 <A0DFE635-EFEC-4670-AD70-5D813E170BEE@linaro.org>
 <5B6570A2-541A-4CF8-98E0-979EA6E3717D@linaro.org>
 <2CB39B34-21EE-4A95-A073-8633CF2D187C@linaro.org>
 <FC24E25F-4578-454D-AE2B-8D8D352478D8@linaro.org>
 <0e3fdf31-70d9-26eb-7b42-2795d4b03722@csail.mit.edu>
 <F5E29C98-6CC4-43B8-994D-0B5354EECBF3@linaro.org>
 <f4b11315-144c-c67d-5143-50b5be950ede@csail.mit.edu>
 <9E95BE27-2167-430F-9C7F-6D4A0E255FF3@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9E95BE27-2167-430F-9C7F-6D4A0E255FF3@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, jmoyer@redhat.com, Theodore Ts'o <tytso@mit.edu>, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com

On 5/22/19 2:12 AM, Paolo Valente wrote:
> 
>> Il giorno 22 mag 2019, alle ore 11:02, Srivatsa S. Bhat <srivatsa@csail.mit.edu> ha scritto:
>>
>>
>> Let's continue here on LKML itself.
> 
> Just done :)
> 
>> The only reason I created the
>> bugzilla entry is to attach the tarball of the traces, assuming
>> that it would allow me to upload a 20 MB file (since email attachment
>> didn't work). But bugzilla's file restriction is much smaller than
>> that, so it didn't work out either, and I resorted to using dropbox.
>> So we don't need the bugzilla entry anymore; I might as well close it
>> to avoid confusion.
>>
> 
> No no, don't close it: it can reach people that don't use LKML.  We
> just have to remember to report back at the end of this.

Ah, good point!

>  BTW, I also
> think that the bug is incorrectly filed against 5.1, while all these
> tests and results concern 5.2-rcX.
> 

Fixed now, thank you for pointing out!
 
Regards,
Srivatsa
VMware Photon OS
